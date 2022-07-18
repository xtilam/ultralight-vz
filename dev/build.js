const { execSync, spawn, exec, spawnSync } = require('child_process')
const fs = require('fs')
const path = require('path')
const md5 = require('md5')
const jsObfuscator = require('javascript-obfuscator')
const config = require('../config')

main()

async function main() {
    const autoIncludeFileAu3 = path.join(config.autoIncludePath, 'auto_include.au3')
    const fileExtensionMD5 = ['.html', '.css', '.json']
    const excludeFileExtensions = ['.LICENSE.txt', '.js.map', '.css.map', 'robots.txt']
    
    const au3BuildConfig = [
        '/in', config.mainAU3,
        '/out', path.join(config.buildPath, config.nameExecutable),
        '/icon', path.join(config.autoITPath, 'Aut2Exe/Icons/AutoIt_Main_v11_256x256_RGB-A.ico'),
        '/nopack',
        '/comp', 2,
        '/x64'
    ]

    if (fs.existsSync(config.buildPath)) fs.rmSync(config.buildPath, { recursive: true })

    await execCommand(`cd ${path.join(__dirname, '../app')} && npm run build`)[1]
    copyResource(path.join(__dirname, '../gui/build'), path.join(config.buildPath, 'assets'))
    await spawnCommand(path.join(config.autoITPath, '/aut2exe/aut2exe.exe'), au3BuildConfig)[1]

    function copyResource(resourcePath, assetsPath) {
        
    }
}


function spawnCommand(...args) {
    const child = spawn.apply(undefined, args)
    child.stdout.on('data', (d) => {
        console.log(d.toString())
    })
    child.stderr.on('data', (d) => {
        console.log(d.toString())
    })
    return [child, new Promise((resolve, reject) => {
        child.on('exit', (code, signal) => {
            resolve([code, signal])
        })
    })]
}

function execCommand(command) {
    const child = exec(command)
    child.stdout.on('data', (d) => {
        console.log(d.toString())
    })
    child.stderr.on('data', (d) => {
        console.log(d.toString())
    })
    return [child, new Promise((resolve, reject) => {
        child.on('exit', (code, signal) => {
            resolve([code, signal])
        })
    })]
}