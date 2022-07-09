import { Button } from '@mui/material';
import React from 'react';
import './App.scss';
import { au3Action } from './au3/au3';
import { AppBarButton } from './components/AppBarButton';

function App() {
  return (
    <div className="App">
      <AppBarButton/>
      <Button onClick={()=>{
        const result = au3Action.findProcess('League of Legends.exe')
        console.log(result)
      }}>findProcess</Button>
    </div>
  );
}

export default App;
