const electron = require('electron')
const { app, BrowserWindow } = electron

const midi = require('midi')
const out = new midi.output()
out.openPort(0)

let mainWindow

function createWindow () {
  mainWindow = new BrowserWindow({height: 800, width: 800})
  mainWindow.loadURL('file://' + __dirname + '/static/index.html')
  mainWindow.webContents.openDevTools()
  setInterval(boop, 1000)
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

let bop = false
function boop () {
  bop = !bop
  // toggle LFO destination
  sendCC(67, bop)
}

function sendCC (number, value) {
  if (typeof value === 'boolean') {
    value = value ? 127 : 0
  }
  out.sendMessage([176, number, value])
}

