from setuptools import setup, find_packages

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setup(
    name="sendit",
    version="1.2.0",
    author="Guillaume Deflandre",
    author_email="guill.deflandre@gmail.com",
    description="a simple and efficient scp file transfer tool with progress bars",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/guideflandre/sendit",
    packages=find_packages(),
    py_modules=["sendit"],
    classifiers=[
        "development status :: 4 - beta",
        "intended audience :: developers",
        "intended audience :: system administrators",
        "license :: osi approved :: mit license",
        "operating system :: posix :: linux",
        "programming language :: python :: 3",
        "programming language :: python :: 3.8",
        "programming language :: python :: 3.9",
        "programming language :: python :: 3.10",
        "programming language :: python :: 3.11",
        "topic :: system :: systems administration",
        "topic :: utilities",
    ],
    python_requires=">=3.8",
    install_requires=[
        "rich-click>=1.6.1",
        "rich>=13.0.0",
    ],
    entry_points={
        "console_scripts": [
            "sendit=sendit:main",
        ],
    },
)
