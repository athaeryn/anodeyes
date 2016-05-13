const electron = require('electron')
const { app, BrowserWindow } = electron

let mainWindow

function createWindow () {
  mainWindow = new BrowserWindow({height: 800, width: 800})
  mainWindow.loadURL('file://' + __dirname + '/static/index.html')
  mainWindow.webContents.openDevTools()
  mainWindow.on('closed', () => {
    mainWindow = null
  })
}

app.on('ready', createWindow)

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', () => {
  if (mainWindow == null) {
    createWindow()
  }
})
