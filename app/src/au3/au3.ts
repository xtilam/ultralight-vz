export const au3Action = {
    findProcess(name: string = 'League of Legends.exe') {
        console.log((window as any).au3)
        return au3('findProcess', name)        
    },
    ultralight: {
        startMoveWindow(){
            au3('Ultralight_StartMoveApp')
        },
        stopMoveWindow(){
            au3('Ultralight_StopMoveApp')
        }
    },
    exit: ()=>au3('exitApp')
}