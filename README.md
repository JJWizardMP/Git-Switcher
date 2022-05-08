## Git and Github switch credentials

![](https://i.ytimg.com/vi/PPQ8m8xQAs8/maxresdefault.jpg)

## Introduction

I wanted to create this script for to switch my git accounts(from the work, university and my personal account) easier only running a bash script.

I used these shell command line tools in this project:

- jq: a shell command line for read easily a json file.
- git: a shell command line for manage a control of versions for software projects
- github-cli: a shell command line for 
connect with the github page repository

## Requeriments

- Write a bash script that allows switch git and github accounts

## Demo

- [Repository](https://github.com/JJWizardMP/Grand-Oasis-Cancun-Test)

## Images

### Running script

![](./front-end/assets/views/view_table.png)

## Technologies

#### Command line

| [jq](https://stedolan.github.io/jq/) | [Git](https://git-scm.com/) | [Github-cli](https://cli.github.com/) |
| :----------------------------------: | :-------------------------: | :-----------------------------------: |

## Application Installation

### Git Switcher:

We need to assing permisions for run the requirements intaller script and the main script(Do not forget config your config.json and add your credentials)

```sh
$ chmod u+x script.sh requirements.sh
```

Run the requirements script

```sh
$ ./requirements.sh
```

Run the main script with one argument(the argument is your account in the config.json)

```sh
$ ./requirements.sh jjwizard
```

## Contribuidores

This project was written by:

- Programmer :
  - [Joan de Jesús Méndez Pool](https://github.com/JJWizardMP)
