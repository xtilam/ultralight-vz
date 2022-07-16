import AppBar from '@mui/material/AppBar';
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import IconButton from '@mui/material/IconButton';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import React from 'react';
import { au3Action } from '../au3/au3';
import { constants } from '../constants/constants';
import { ExitSVG } from '../svg/exitSVG';

export function AppBarButton() {
    return (
        <Box sx={{ flexGrow: 1 }}
            onMouseDown={window.startMoveWindow}
            onMouseUp={window.stopMoveWindow}
            id="app-bar"
        >
            <AppBar position="static">
                <Toolbar>
                    <IconButton
                        size="large"
                        edge="start"
                        color="inherit"
                        aria-label="menu"
                        sx={{ mr: 2 }}
                    >
                        {/* <MenuIcon /> */}
                    </IconButton>
                    <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
                        {constants.appName + ' ' + constants.version}
                    </Typography>
                    <div id="window-buttons">
                        <Button color="primary" variant='contained' >
                            <ExitSVG fill="#fff" />
                        </Button>
                        <Button color="primary" variant='contained'>
                            <ExitSVG fill="#fff" />
                        </Button>
                        <Button color="error" variant='contained' onClick={au3Action.exit}>
                            <ExitSVG fill="#fff" />
                        </Button>
                    </div>
                </Toolbar>
            </AppBar>
        </Box>
    );
}