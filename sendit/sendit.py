#!/usr/bin/env python3
"""
sendit - A command-line tool for transferring files via SCP

Installation:
    1. Save this file as 'sendit.py'
    2. Install dependencies: pip install rich-click rich
    3. Make executable: chmod +x sendit.py
    4. Create symlink: sudo ln -s $(pwd)/sendit.py /usr/local/bin/sendit
    
Or use the setup.py file for proper installation.
"""

import subprocess
import sys
import os
import re
import configparser
from pathlib import Path
from threading import Thread
import rich_click as click
from rich.progress import Progress, SpinnerColumn, TextColumn, BarColumn, TaskProgressColumn, TimeRemainingColumn
from rich.console import Console

# Configure rich-click for Casanovo-style help display
click.rich_click.USE_RICH_MARKUP = True
click.rich_click.USE_MARKDOWN = False
click.rich_click.SHOW_ARGUMENTS = True
click.rich_click.GROUP_ARGUMENTS_OPTIONS = True
click.rich_click.STYLE_ERRORS_SUGGESTION = "magenta italic"
click.rich_click.ERRORS_SUGGESTION = ""
click.rich_click.STYLE_OPTION = "bold cyan"
click.rich_click.STYLE_SWITCH = "bold green"
click.rich_click.STYLE_METAVAR = "bold yellow"
click.rich_click.STYLE_METAVAR_SEPARATOR = "dim"
click.rich_click.STYLE_HEADER_TEXT = "bold blue"
click.rich_click.STYLE_USAGE = "bold yellow"
click.rich_click.STYLE_USAGE_COMMAND = "bold"
click.rich_click.STYLE_OPTION_DEFAULT = "dim"
click.rich_click.STYLE_REQUIRED_SHORT = "red"
click.rich_click.STYLE_REQUIRED_LONG = "red"
click.rich_click.COLOR_SYSTEM = "auto"
click.rich_click.MAX_WIDTH = None  # Fit terminal width

__version__ = "1.2.0"

console = Console()

# Config file location
CONFIG_DIR = Path.home() / ".config" / "sendit"
CONFIG_FILE = CONFIG_DIR / "config.ini"


def load_config():
    """Load configuration from config file."""
    config = configparser.ConfigParser()
    
    if CONFIG_FILE.exists():
        config.read(CONFIG_FILE)
    else:
        # Create default config
        config['DEFAULT'] = {
            'remote_host': '',
            'remote_user': '',
        }
    
    return config


def save_config(config):
    """Save configuration to config file."""
    CONFIG_DIR.mkdir(parents=True, exist_ok=True)
    with open(CONFIG_FILE, 'w') as f:
        config.write(f)


def get_default_remote(profile=None):
    """Get default remote host/user from config.

    Args:
        profile: Optional profile name to use. If None, uses DEFAULT profile.
    """
    config = load_config()
    section = profile if profile else 'DEFAULT'

    # Check if profile exists
    if profile and not config.has_section(profile):
        console.print(f"[red]Error: Profile '{profile}' not found in configuration[/red]")
        console.print("[yellow]Use 'sendit config list' to see available profiles[/yellow]")
        sys.exit(1)

    host = config.get(section, 'remote_host', fallback='')
    user = config.get(section, 'remote_user', fallback='')

    if host and user:
        return f"{user}@{host}"
    return None


def parse_scp_progress(line):
    """Parse SCP progress output to extract percentage and speed."""
    # SCP output format: filename  45%  123MB   1.2MB/s   00:30 ETA
    match = re.search(r'(\d+)%', line)
    if match:
        return int(match.group(1))
    return None


def run_scp_with_progress(scp_command, description):
    """Run SCP command with a progress indicator."""

    try:
        # Run SCP directly without capturing output
        # This allows password prompts and progress display to work
        return_code = subprocess.call(scp_command)

        return return_code

    except Exception as e:
        console.print(f"[red]Error during transfer: {e}[/red]")
        return 1


@click.group(invoke_without_command=True, context_settings=dict(help_option_names=["-h", "--help"]))
@click.pass_context
@click.option(
    "-f", "--file",
    type=click.Path(exists=False),
    help="The file to transfer",
    metavar="FILE",
    default=None
)
@click.option(
    "-d", "--directory",
    type=str,
    help="The destination directory",
    metavar="DIRECTORY",
    default=None
)
@click.option(
    "-L", "--Local",
    "mode",
    flag_value="local",
    help="Transfer from remote to local (download)",
    default=None
)
@click.option(
    "-R", "--Remote",
    "mode",
    flag_value="remote",
    help="Transfer from local to remote (upload)",
    default=None
)
@click.option(
    "-r", "--recursive",
    is_flag=True,
    help="Recursively copy entire directories",
    default=False
)
@click.option(
    "-s", "--server",
    type=str,
    help="Named server profile to use",
    metavar="PROFILE",
    default=None
)
@click.version_option(
    version=__version__,
    prog_name="sendit",
    message="%(prog)s version %(version)s"
)
def main(ctx, file, directory, mode, recursive, server):
    """
    [bold blue]sendit[/bold blue] - A simple and efficient SCP file transfer tool

    Transfer files between local and remote systems using SCP (Secure Copy Protocol).

    [bold yellow]Examples:[/bold yellow]

      # Upload a local file to remote server
      sendit -f /path/to/local/file.txt -d user@host:/remote/path/ -R

      # Download a file from remote server to local directory
      sendit -f user@host:/remote/path/file.txt -d /local/path/ -L

      # Upload a directory recursively
      sendit -f /path/to/directory -d user@host:/remote/path/ -R -r

      # Short form (remote upload if default host is configured)
      sendit -f myfile.pdf -d /remote/documents/

      # Configure default remote host
      sendit config set-host myserver.com myusername

      # Create a named server profile
      sendit config set-host prod-server.com produser --profile production

      # Use a named server profile
      sendit -f myfile.pdf -d /remote/documents/ -s production
    
    [bold yellow]Configuration Commands:[/bold yellow]
    
      sendit config set-host HOST USER    Set default remote host and user
      sendit config show                  Show current configuration
      sendit config clear                 Clear configuration
    
    [bold yellow]Notes:[/bold yellow]
    
      • SSH keys or password authentication will be handled by SCP
      • Make sure you have SSH access to the remote server
      • The destination directory must exist on the target system
      • Progress bars show transfer status in real-time
    """
    
    # If no subcommand and no file option, show help
    if ctx.invoked_subcommand is None:
        if not file or not directory:
            click.echo(ctx.get_help())
            ctx.exit()

        # Handle transfer
        transfer_file(file, directory, mode, recursive, server)


def transfer_file(file, directory, mode, recursive, server=None):
    """Handle file transfer logic.

    Args:
        file: Source file path
        directory: Destination directory path
        mode: Transfer mode ('remote' or 'local')
        recursive: Whether to copy directories recursively
        server: Named server profile to use (optional)
    """

    # Default to remote if not specified
    if mode is None:
        mode = "remote"

    # Load config for default remote (using profile if specified)
    default_remote = get_default_remote(server)

    # Determine transfer direction and build scp command
    if mode == "remote":
        # Upload: local to remote
        # Validate that file exists locally
        if not os.path.exists(file):
            console.print(f"[red]Error: Local file '{file}' does not exist[/red]")
            sys.exit(1)

        # Auto-prepend default remote if directory doesn't contain @
        if default_remote and '@' not in directory and ':' not in directory:
            directory = f"{default_remote}:{directory}"

        # Build scp command with optional recursive flag
        scp_command = ["scp"]
        if recursive:
            scp_command.append("-r")
        scp_command.extend([file, directory])

        action = "Uploading"
        source = file
        destination = directory
    else:
        # Download: remote to local
        # Auto-prepend default remote if file doesn't contain @
        if default_remote and '@' not in file and file.startswith('/'):
            file = f"{default_remote}:{file}"

        # Validate that destination directory exists locally
        local_dir = Path(directory)
        if not local_dir.exists():
            console.print(f"[red]Error: Local directory '{directory}' does not exist[/red]")
            sys.exit(1)

        if not local_dir.is_dir():
            console.print(f"[red]Error: '{directory}' is not a directory[/red]")
            sys.exit(1)

        # Build scp command with optional recursive flag
        scp_command = ["scp"]
        if recursive:
            scp_command.append("-r")
        scp_command.extend([file, directory])

        action = "Downloading"
        source = file
        destination = directory
    
    # Display transfer info
    item_type = "directory" if recursive else "file"
    console.print(f"\n[bold cyan]{action} {item_type}...[/bold cyan]")
    console.print(f"  [white]Source:      {source}[/white]")
    console.print(f"  [white]Destination: {destination}[/white]\n")
    
    # Execute SCP command with progress
    try:
        return_code = run_scp_with_progress(
            scp_command,
            f"[cyan]{action}[/cyan]"
        )

        if return_code == 0:
            console.print("\n[bold green]✓ Transfer completed successfully![/bold green]")
            sys.exit(0)
        else:
            console.print(f"\n[bold red]✗ Transfer failed with exit code {return_code}[/bold red]")
            if return_code == 1:
                console.print("[yellow]Possible causes:[/yellow]")
                console.print("  • Authentication failed (wrong password/key)")
                console.print("  • Remote directory doesn't exist")
                console.print("  • Permission denied")
                console.print("  • Network connection issue")
            sys.exit(return_code)
        
    except FileNotFoundError:
        console.print("\n[bold red]✗ Error: 'scp' command not found. Please install OpenSSH.[/bold red]")
        sys.exit(127)
    
    except KeyboardInterrupt:
        console.print("\n\n[bold yellow]✗ Transfer cancelled by user[/bold yellow]")
        sys.exit(130)
    
    except Exception as e:
        console.print(f"\n[bold red]✗ Unexpected error: {str(e)}[/bold red]")
        sys.exit(1)


@main.group()
def config():
    """Manage sendit configuration."""
    pass


@config.command("set-host")
@click.argument("host")
@click.argument("user")
@click.option(
    "-p", "--profile",
    type=str,
    help="Named profile to save configuration under",
    metavar="NAME",
    default=None
)
def set_host(host, user, profile):
    """Set default remote host and username.

    [bold yellow]Examples:[/bold yellow]

      sendit config set-host myserver.com myusername
      sendit config set-host server2.com user2 --profile server2
    """
    cfg = load_config()

    # Use profile name if provided, otherwise use DEFAULT
    section = profile if profile else 'DEFAULT'

    # Create section if it doesn't exist (except for DEFAULT which always exists)
    if profile and not cfg.has_section(profile):
        cfg.add_section(profile)

    cfg[section]['remote_host'] = host
    cfg[section]['remote_user'] = user
    save_config(cfg)

    console.print(f"\n[bold green]✓ Configuration saved![/bold green]")
    if profile:
        console.print(f"  [white]Profile: {profile}[/white]")
        console.print(f"  [white]Remote: {user}@{host}[/white]\n")
        console.print("[dim]Use this profile with:[/dim]")
        console.print(f"[dim]  sendit -f myfile.txt -d /remote/path/ -s {profile}[/dim]\n")
    else:
        console.print(f"  [white]Default remote: {user}@{host}[/white]\n")
        console.print("[dim]You can now use simplified commands like:[/dim]")
        console.print("[dim]  sendit -f myfile.txt -d /remote/path/[/dim]\n")


@config.command("show")
def show_config():
    """Show current configuration."""
    cfg = load_config()

    console.print("\n[bold blue]Current Configuration:[/bold blue]")
    console.print(f"  [white]Config file: {CONFIG_FILE}[/white]")

    host = cfg.get('DEFAULT', 'remote_host', fallback='')
    user = cfg.get('DEFAULT', 'remote_user', fallback='')

    if host and user:
        console.print(f"  [white]Default remote: {user}@{host}[/white]")
    else:
        console.print("  [dim]No default remote configured[/dim]")

    console.print()


@config.command("list")
def list_profiles():
    """List all configured server profiles."""
    cfg = load_config()

    console.print("\n[bold blue]Configured Server Profiles:[/bold blue]\n")

    # Show DEFAULT profile
    host = cfg.get('DEFAULT', 'remote_host', fallback='')
    user = cfg.get('DEFAULT', 'remote_user', fallback='')

    if host and user:
        console.print(f"  [bold cyan]DEFAULT[/bold cyan] (used when no -s flag is provided)")
        console.print(f"    [white]{user}@{host}[/white]")
    else:
        console.print(f"  [bold cyan]DEFAULT[/bold cyan]")
        console.print(f"    [dim]Not configured[/dim]")

    # Show all other profiles
    profiles = [section for section in cfg.sections() if section != 'DEFAULT']

    if profiles:
        for profile in profiles:
            host = cfg.get(profile, 'remote_host', fallback='')
            user = cfg.get(profile, 'remote_user', fallback='')

            console.print(f"\n  [bold cyan]{profile}[/bold cyan]")
            if host and user:
                console.print(f"    [white]{user}@{host}[/white]")
            else:
                console.print(f"    [dim]Incomplete configuration[/dim]")
    else:
        console.print("\n  [dim]No named profiles configured[/dim]")

    console.print("\n[dim]Use 'sendit -s PROFILE' to select a specific profile[/dim]\n")


@config.command("clear")
def clear_config():
    """Clear all configuration."""
    if CONFIG_FILE.exists():
        CONFIG_FILE.unlink()
        console.print("\n[bold green]✓ Configuration cleared![/bold green]\n")
    else:
        console.print("\n[dim]No configuration to clear.[/dim]\n")


@config.command("delete")
@click.argument("profile")
def delete_profile(profile):
    """Delete a named server profile.

    [bold yellow]Example:[/bold yellow]

      sendit config delete server2
    """
    if profile == "DEFAULT":
        console.print("\n[red]Error: Cannot delete the DEFAULT profile[/red]")
        console.print("[yellow]Use 'sendit config clear' to clear all configuration[/yellow]\n")
        sys.exit(1)

    cfg = load_config()

    if not cfg.has_section(profile):
        console.print(f"\n[red]Error: Profile '{profile}' does not exist[/red]")
        console.print("[yellow]Use 'sendit config list' to see available profiles[/yellow]\n")
        sys.exit(1)

    cfg.remove_section(profile)
    save_config(cfg)

    console.print(f"\n[bold green]✓ Profile '{profile}' deleted![/bold green]\n")


if __name__ == "__main__":
    main()
