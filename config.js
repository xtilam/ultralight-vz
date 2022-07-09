const path = require('path')

module.exports = {
    dllBuildPath: [
        "C:/Users/ztila/source/repos/AU3_Utralight/x64/Debug/AU3Utralight.dll"
    ],
    mainAU3: path.join(__dirname, '/src/au3/main.au3'),
    autoCleanDLLBuild: true,
    autoITPath: 'C://Program Files (x86)//AutoIt3',
    buildPath: path.join(__dirname, 'build'),
    autoIncludePath: path.join(__dirname, '/src/au3/auto_include'),
    nameExecutable: 'ultralight.exe'
}

/**@type HTMLElement */
let button = 12