# Bedrock Server Manager Portable

Portable multi-instance launcher for [Minecraft Bedrock Server Manager](https://github.com/schrebra/Minecraft-Bedrock-Manager-CSharp).

## Structure

```text
BSM\
├── launcher.bat
├── App\
│   └── BedrockServerManager.exe
└── Instances\
    ├── Default\
    ├── Survival\
    └── Testing\
```

## Usage

* Put `BedrockServerManager.exe` in `App`.
* Create server instances as folders inside `Instances`.
* Run `launcher.bat`.
* Press **Enter** to launch `Default`.
* Press **R** to refresh the instance list.
