import React, { useState } from 'react';
import './sass/App.scss';
import { AppBarButton } from './components/AppBarButton';


function App() {
  const [href, setHref] = useState(window.location.href)

  return (
    <div className="App">
      <AppBarButton />
      {/* <div>href: <a>{href}</a></div>
      <Button variant='contained' onClick={() => {
        setHref(window.location.href)
      }}>This is button 2</Button> */}
    </div>
  );
}
 
export default App;
