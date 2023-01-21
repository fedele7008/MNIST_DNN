### OUT DATED ###
### README.md in process ###

<p align="center">
  <H1 align="center">MNIST DNN</H1>
  <H3 align="center">MNIST Deep Neural Network from Scratch</H3>
  <table align="center">
    <tbody>
      <tr>
        <td>License</th>
        <td>MIT</th>
      </tr>
      <tr>
        <td>Version</td>
        <td>0.1.0</td>
      </tr>
      <tr>
        <td>Last Release</td>
        <td>N/A</td>
      </tr>
    </tbody>
  </table>
</p>

## Contents
1. <a href="#members">Members</a>
2. <a href="#about">About</a>
3. <a href="#structure">Structure</a>
4. <a href="#install">How to: Install</a>
5. <a href="#run">How to: Run</a>
6. <a href="#credit">Credit</a>

## <div id="members">Members</div>
| Name | E-mail | LinkedIn |
| :--- | :---: | :---: |
| John Yoon | <a href="mailto:fedelejohn7008@gmail.com" target="_blank"><img src="https://img.shields.io/badge/Email-fedelejohn7008@gmail.com-FFFFFF?style=flat&logo=Gmail&logoColor=EA4335"/></a> | <a href="https://www.linkedin.com/in/john-yoon-33b8771a8/" target="_blank"><img src="https://img.shields.io/badge/LinkedIn-John Yoon-FFFFFF?style=flat&logo=LinkedIn&logoColor=0A66C2"/></a> |
| Joon Kim | <a href="mailto:kimsjoon14@gmail.com" target="_blank"><img src="https://img.shields.io/badge/Email-kimsjoon14@gmail.com-FFFFFF?style=flat&logo=Gmail&logoColor=EA4335"/></a> | <a href="https://www.linkedin.com/in/joonkim14/" target="_blank"><img src="https://img.shields.io/badge/LinkedIn-Joon Kim-FFFFFF?style=flat&logo=LinkedIn&logoColor=0A66C2"/></a> |

## <div id="about">About</div>
MNIST_DNN Stands for "MNIST Dataset Deep Neural Network" Project. \
In this project, we have 3 different core components: 
* ClientUI - User will be able to freely control our MNIST-DNN Module from web-view via API-Server.
* API-Server - ClientUI will request API to control the MNIST-DNN Module.
* MNIST-DNN - Core of Machine Learning with MNIST Dataset.

| Core | Languages | Note |
| :---: | :---: | :---: |
| ClientUI   | <img src="https://img.shields.io/badge/HTML-E34F26?style=flat&logo=HTML5&logoColor=FFFFFF"/> <img src="https://img.shields.io/badge/CSS-1572B6?style=flat&logo=CSS3&logoColor=FFFFFF"/> <img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=flat&logo=JavaScript&logoColor=FFFFFF"/>  | Use Canvas tag to model / train / test DNN Model |
| API-Server | <img src="https://img.shields.io/badge/PYTHON-3776AB?style=flat&logo=Python&logoColor=FFFFFF"/> | Use Flask to launch API Server (REST API) |
| MNIST-DNN | <img src="https://img.shields.io/badge/PYTHON-3776AB?style=flat&logo=Python&logoColor=FFFFFF"/> | Deep Neural Network package without using ML libraries | 

## <div id="structure">Structure<div>
```
MNIST_DNN/
├── client/                           # Core: 'ClientUI'
│   ├── doc/                          # [ClientUI] Documentation files
│   └── src/                          # [ClientUI] Source files
├── service/
│   ├── api/                          # Core: 'API-Server'
│   ├── dnn/                          # Core: 'MNIST-DNN'
│   └── tests/                        # unit test suites
├── dev/                              # Local development configs
│   └── mnist-dnn-venv/               # Virtual Envirnoment for `API-Server` and `MNIST-DNN`
├── env_setup.sh                      # Initial setup script (Mac/Linux only)
├── LICENSE                           # MIT License
├── .gitignore
└── README.md
```

> `client/` folder is a 'WEB project' recommended IDE: Google Chrome, VS Code, Atom

> `service/` folder is a 'Python project' recommended IDE: PyCharm, VS Code

> `dev/` folder is used for Local development configurations (python virtual environment, etc.), this **SHOULD NOT** be uploaded to GitHub (It is listed in `.gitignore` by default)
## <div id="install">How to: Install<div>
### Requirements:
* Browser (one of)
  * Chrome 4.0
  * Edge 9.0
  * FireFox 2.0
  * Safari 3.1
* Python 3.X
* PIP 3.X

#### Step 1
Clone the git repo to your local directory, use `git clone https://github.com/fedele7008/MNIST_DNN.git` in your desired location.

#### Step 2
Set up the virtual environment for python.

**If you are using Mac/Linux:**
Goto `MNIST_DNN/` (project root) and run `source env_setup.sh`. This will automatically detect Python and PIP, initiate virtual environment in `dev/` and install required libraries for the project. For more usages, please check out `source env_setup.sh --help`.

**If you are using Windows:**
You must manually create `dev/` and setup the virtual environment there. For more details, please contact `@John Yoon <fedelejohn7008@gmail.com>`.

> To activate the virtual environment, run `source <path-to-project-root>/dev/mnist-dnn-venv/bin/activate`

> To deactivate the virtual environment, run `deactivate`

## <div id="run">How to: Run<div>
After you install the project, activate the virtual environment using `source <path-to-project-root>/dev/mnist-dnn-venv/bin/activate`
Then run the API Server by `python <path-to-project-root>/service/api/app.py`.

Then open the client for use.

## <div id="credit">Credit<div>
#### Special Thanks
* Daniel Lee

#### Resources
* Project Structure [[link](https://www.holaxprogramming.com/2017/06/28/python-project-structures/)]
* ASCII Art [[link](http://paulbourke.net/dataformats/asciiart/)]
