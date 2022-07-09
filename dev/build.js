const { execSync, spawn, exec, spawnSync } = require('child_process')
const fs = require('fs')
const path = require('path')
const md5 = require('md5')
const jsObfuscator = require('javascript-obfuscator')
const config = require('../config')

main()

async function main(){
    const autoIncludeFileAu3 = path.join(config.autoIncludePath, 'auto_include.au3')
    const fileExtensionMD5 = ['.html', '.css', '.json']
    const excludeFileExtensions = ['.LICENSE.txt', '.js.map', '.css.map', 'robots.txt']
    const au3BuildConfig =  [
        '/in', config.mainAU3,
        '/out', path.join(config.buildPath, config.nameExecutable),
        '/icon', path.join(config.autoITPath, 'Aut2Exe/Icons/AutoIt_Main_v11_256x256_RGB-A.ico'),
        '/nopack',
        '/comp', 2,
        '/x64'
    ]

    // if(fs.existsSync(config.buildPath)) fs.rmSync(config.buildPath, {recursive: true})
    fs.mkdirSync(config.buildPath)
    
    // await execCommand(`cd ${path.join(__dirname, '../gui')} && npm run build`)[1]
    // copyResource(path.join(__dirname, '../gui/build'), path.join(config.buildPath, 'assets'))
    fs.writeFileSync(autoIncludeFileAu3, `#include-once\n#include "production/production.au3"`)
    await spawnCommand(path.join(config.autoITPath, '/aut2exe/aut2exe.exe'), au3BuildConfig)[1]
    fs.writeFileSync(autoIncludeFileAu3, `#include-once\n#include "dev/dev.au3"`)

    function copyResource(resourcePath, assetsPath){
        let md5Resources = []
        const autoResourceAu3Path = path.join(config.autoIncludePath, 'production/auto_resource.au3')
        // fs.mkdirSync(assetsPath)

        copy()

        function copy(subPath = ''){
            let currentPath = path.join(resourcePath, subPath)
            const stats = fs.statSync(currentPath)
            if(stats.isDirectory()){
                const files = fs.readdirSync(currentPath)
                for(const file of files){
                    copy(`${subPath}/${file}`)
                }
            }else{
                for(const ext of excludeFileExtensions){
                    if(currentPath.endsWith(ext)) return
                }

                const ext = path.extname(currentPath)
                const targetPath = path.join(assetsPath, subPath)
                if(ext === '.js'){
                    const jsObfuscated = jsObfuscator.obfuscate(fs.readFileSync(currentPath, {encoding: 'utf-8'})).getObfuscatedCode()
                    md5Resources.push(`'0x${md5(jsObfuscated)}'`)
                    const targetDirectory = path.dirname(targetPath)
                    if(!fs.existsSync(targetDirectory)) fs.mkdirSync(targetDirectory, {recursive: true})
                    fs.writeFileSync(targetPath, jsObfuscated, {encoding: 'utf-8', })
                }else{
                    for(const md5Ext of fileExtensionMD5){
                        if(md5Ext === ext) md5Resources.push(`'0x${md5(fs.readFileSync(currentPath, {encoding: 'utf-8'}))}'`)
                    }
                    fs.cpSync(currentPath, targetPath)
                }
            }
        }
        fs.writeFileSync(autoResourceAu3Path,`Global $md5Arr[] = [${md5Resources.join(",")}]`, {encoding: 'utf-8'})
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
    return [child, new Promise((resolve, reject)=>{
        child.on('exit', (code, signal)=>{
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
    return [child, new Promise((resolve, reject)=>{
        child.on('exit', (code, signal)=>{
            resolve([code, signal])
        })
    })]
}