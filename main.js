const electron = require('electron')
const { app, BrowserWindow, ipcMain } = electron

const midi = require('midi')
const out = new midi.output()
try {
  out.openPort(0)
} catch (e) {
  console.log('no MIDI device connected')
}

let mainWindow

function createWindow () {
  mainWindow = new BrowserWindow({height: 1100, width: 800})
  mainWindow.loadURL('file://' + __dirname + '/static/index.html')
  mainWindow.on('closed', () => { mainWindow = null })
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

ipcMain.on('asynchronous-message', (event, msg) => {
  const { number, value } = msg
  console.log(number, value)
  out.sendMessage([176, number, value])
})

