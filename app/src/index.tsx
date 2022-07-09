import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';
import { au3Action } from './au3/au3';

main()

async function main() {
  await waitAu3()
  const root = ReactDOM.createRoot(
    document.getElementById('root') as HTMLElement
  );
  root.render(
    <React.StrictMode>
      <App />
    </React.StrictMode>
  );

}

function waitAu3(){
  return new Promise((resolve, reject)=>{
    setInterval(()=>{
      const au3c = (window as any).au3
      if(!au3c) return
      au3Action.setAu3Call(au3c)
      window.addEventListener('blur', au3Action.ultralight.stopMoveWindow)
      resolve(0)
    }, 100)
  })
}

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
