let au3Call = (window as any).au3

export const au3Action = {
    setAu3Call(au3C){
        au3Call = au3C
    },
    findProcess(name: string = 'League of Legends.exe') {
        console.log((window as any).au3)
        return au3Call('findProcess', name)        
    },
    ultralight: {
        startMoveWindow(){
            au3Call('Ultralight_StartMoveApp')
        },
        stopMoveWindow(){
            au3Call('Ultralight_StopMoveApp')
        }
    },
    exit: ()=>au3Call('exitApp')
}