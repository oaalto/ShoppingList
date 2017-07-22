import './main.css'
import localStoragePorts from "elm-localstorage-ports"
import Elm from './App.elm'

const root = document.getElementById('root')

const app = Elm.App.embed(root)

localStoragePorts.register(app.ports);
