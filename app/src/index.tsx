import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";
import "./sass/App.scss"

main()

async function main() {
    await waitUltralight()

    const root = ReactDOM.createRoot(
        document.getElementById('root') as HTMLElement
    );
    console.log('app start', window.stopMoveWindow)
    root.render(
        <React.StrictMode>
            <App />
        </React.StrictMode>
    );
}

function waitUltralight() {
    return new Promise((resolve) => {
        const interval = setInterval(() => {
            if (!window.au3) return
            console.log('wait au3 start')
            window.addEventListener('blur', window.stopMoveWindow)
            clearTimeout(interval)
            resolve(0)
        }, 20)
    })
}