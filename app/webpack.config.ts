//@ts-nocheck
//@ts-ignore
import * as liveServer from 'live-server';
import path from "path";
import { Configuration } from "webpack";
import MiniCssExtractPlugin from 'mini-css-extract-plugin';



export default function (env, argv) {
  const isProduction = argv.mode === 'production'

  const plugins = []

  if (!isProduction) {
    startServer()
    plugins.push(new MiniCssExtractPlugin({ filename: 'app.css' }))
  }
  const config: Configuration = {
    entry: ["./src/index.tsx", './src/sass/App.scss'],
    watch: !isProduction,
    plugins: plugins,
    module: {
      rules: [
        {
          test: /\.(ts|js)x?$/,
          exclude: /node_modules/,
          use: {
            loader: "babel-loader",
            options: {
              presets: [
                "@babel/preset-env",
                "@babel/preset-react",
                "@babel/preset-typescript",
              ],
            },
          },
        },
        { // a loader loads file with matching extension no matter
          // if it is listed in entry: or imported inside js
          test: /\.(sc|sa|c)ss/,
          use: isProduction
            ? [{ loader: 'style-loader', }, { loader: 'css-loader' }, { loader: 'sass-loader' }]
            : [MiniCssExtractPlugin.loader, "css-loader", "sass-loader"],
          include: [path.resolve(__dirname, "src")],
        }
      ],
    },
    devtool: !isProduction && 'inline-source-map',
    resolve: {
      extensions: [".tsx", ".ts", ".js"],
    },
    output: {
      path: path.resolve(__dirname, isProduction ? "build" : "public"),
      filename: "bundle.js",
    }
  };

  return config
}

function startServer() {

  var params = {
    port: 3000, // Set the server port. Defaults to 8080.
    host: "0.0.0.0", // Set the address to bind to. Defaults to 0.0.0.0 or process.env.IP.
    root: path.join(__dirname, '/public'), // Set root directory that's being served. Defaults to cwd.
    open: false, // When false, it won't load your browser by default.
    ignore: 'scss,my/templates', // comma-separated string for paths to ignore
    file: "index.html", // When set, serve this file (server root relative) for every 404 (useful for single-page applications)
    wait: 1000, // Waits for all changes, before reloading. Defaults to 0 sec.
    mount: [['/components', './node_modules']], // Mount a directory to a route.
    logLevel: 2, // 0 = errors only, 1 = some, 2 = lotsm
    middleware: [function (req, res, next) {
      next();
    }] // Takes an array of Connect-compatible middleware that are injected into the server middleware stack
  };

  liveServer.start(params);
}