const { execSync, spawn, exec } = require('child_process')
const filewatcher = require('filewatcher')
const fs = require('fs')
const path = require('path')
const { dllBuildPath } = require('../config')
const au3Config = require('../config')
const nodemon = require('nodemon')
const { exit } = require('process')
require('colors')

main()

async function main() {

    let au3Process;
    let isStartApp = false
    const localAu3Path = path.join(__dirname, 'au3')
    const au3ExecutePath = path.join(localAu3Path, 'AutoIt3_x64.exe')
    const autoIt3WrapperAu3Path = path.join(localAu3Path, 'SciTE/AutoIt3Wrapper/AutoIt3Wrapper.au3')


    copyAu3Execute()
    watchBuildDLL()
    watchAU3()


    function execCommand(...args) {
        const child = spawn.apply(undefined, args)
        child.stdout.on('data', (d) => {
            process.stdout.write(d.toString())
        })
        child.stderr.on('data', (d) => {
            process.stderr.write(d.toString())
        })
        return child
    }


    function watchAU3() {
        startApp()
        const mon = nodemon({
            exec: ``,
            cwd: path.join(au3Config.autoITPath),
            watch: path.join(path.dirname(au3Config.mainAU3), '**'),
            ext: 'au3',
            stdout: true,
            stdin: true
        })
        mon.on("restart", function (files) {
            startApp()
        })
    }

    function copyAu3Execute() {
        const includePath = path.join(localAu3Path, 'Include')
        if (fs.existsSync(includePath)) fs.rmSync(includePath, { recursive: true })
        fs.copyFileSync(path.join(au3Config.autoITPath, 'AutoIt3_x64.exe'), path.join(localAu3Path, 'AutoIt3_x64.exe'))
        fs.copyFileSync(path.join(au3Config.autoITPath, 'AutoIt3.exe'), path.join(localAu3Path, 'AutoIt3.exe'))
        fs.copyFileSync(path.join(au3Config.autoITPath, 'Au3Check.exe'), path.join(localAu3Path, 'Au3Check.exe'))
        fs.copyFileSync(path.join(au3Config.autoITPath, 'Au3Check.dat'), path.join(localAu3Path, 'Au3Check.dat'))
        if (!fs.existsSync(path.dirname(autoIt3WrapperAu3Path))) fs.mkdirSync(path.dirname(autoIt3WrapperAu3Path), { recursive: true })
        fs.copyFileSync(path.join(au3Config.autoITPath, 'SciTE/AutoIt3Wrapper/AutoIt3Wrapper.au3'), autoIt3WrapperAu3Path)
        copyRecursiveSync(path.join(au3Config.autoITPath, 'Include'), includePath)
    }

    async function watchBuildDLL() {
        const watcherBuildDLL = new filewatcher()

        for (const dll of dllBuildPath) {
            fs.existsSync(dll) && await copyDLLBuild(dll)
            watcherBuildDLL.add(dll)
        }

        watcherBuildDLL.on('change', async function (dir) {
            console.log('dll change')
            await copyDLLBuild(dir)
        })


        function copyDLLBuild(dir, maxTime = 10000) {
            const dllBinFolder = path.join(path.dirname(au3Config.mainAU3), 'bin')

            const dest = path.join(dllBinFolder, path.basename(dir))
            if (!fs.existsSync(dllBinFolder)) fs.mkdirSync(dllBinFolder, { recursive: true })

            const startTime = (new Date()).getTime()

            const localInterval = setInterval(() => {
                console.log('wait copy')
                const now = (new Date()).getTime()

                if (now - startTime > maxTime) return clearTimeout(localInterval)
                if (!fs.existsSync(dir)) return clearTimeout(localInterval)

                try {
                    au3Process && au3Process.kill()
                    console.log('clear build dll', dir)
                    fs.existsSync(dest) && fs.rmSync(dest)
                    fs.copyFileSync(dir, dest)
                    startApp()
                    clearTimeout(localInterval)
                    console.log('=> dll file copy successfully'.green.green.bold)
                } catch (error) {
                    console.log('=> copying dll ...'.yellow.bold, error.message)
                }

            }, 300)
        }
    }



    function startApp() {
        if (isStartApp) return
        isStartApp = true

        setTimeout(() => {
            if (au3Process) {
                try {
                    execSync(`taskkill /f /pid ${au3Process.pid}`)
                } catch (error) { }
                console.log('=> restart au3 app\n'.green.bold)
            } else {
                console.log('=> start au3 app\n'.green.bold)
            }

            let currentProcess = execCommand(au3ExecutePath, [
                autoIt3WrapperAu3Path,
                '/run',
                '/x64',
                '/prod',
                '/ErrorStdOut',
                '/in',
                `${au3Config.mainAU3}`
            ])
            // let currentProcess = execCommand(au3ExecutePath, [`${au3Config.mainAU3}`, `/errorstdout`])
            currentProcess.on('exit', (exitCode) => {
                if (au3Process !== currentProcess) return
                console.log('=> exit au3 app\n'.red.bold)
            })

            au3Process = currentProcess

            isStartApp = false
        }, 100)
    }

    setInterval(() => 1, 9999999)
}

function copyRecursiveSync(src, dest) {
    var exists = fs.existsSync(src);
    var stats = exists && fs.statSync(src);
    var isDirectory = exists && stats.isDirectory();
    if (isDirectory) {
        if (!fs.existsSync(dest)) fs.mkdirSync(dest);
        fs.readdirSync(src).forEach(function (childItemName) {
            copyRecursiveSync(path.join(src, childItemName),
                path.join(dest, childItemName));
        });
    } else {
        fs.copyFileSync(src, dest);
    }
};