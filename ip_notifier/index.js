const getopt = require('node-getopt');
const express = require('express');
const consola = require('consola');
const bodyParser = require('body-parser');
const request = require("request");

const controllers = require('./controllers')

function server_main(config) {
  const app = express();

  app.use(bodyParser.json());
  app.use('/', controllers(config));

  const port = config.server.listen.port;
  const address = config.server.listen.address;
  app.listen(port, address, function () {
    consola.ready({
      message: `Server listening on http://${address}:${port}`,
      badge: true,
    });
  });
}

function client_main(config) {
  var callback = function () {
    var opt = {
      uri: `http://${config.client.serverEndpoint}/api/notifier`,
      method: "POST",
      auth: {
        bearer: config.client.accessToken,
      },
      json: {
        clientName: config.client.clientName,
        mailTo: config.client.mailTo,
      },
    };
    request(opt, function (error, resp, body) {
      if (error) {
        consola.error(error);
      } else if (resp.statusCode !== 203) {
        consola.error(body);
      }
    });
  };
  callback();
  setInterval(callback, 1000 * 60 * 5);
}

function main() {
  opt = getopt
    .create([
      ["s", "server", "Run as server."],
      ["", "server-mail-config=ARG", "指定服务端发送邮件使用的服务器。", "gmail"],
      ["c", "client", "Run as client."],
      ["", "client-server-endpoint=ARG", "客户端请求的地址。"],
      ["", "client-mail-to=ARG", "指定客户端IP发送到的邮箱地址。"],
      ["", "client-name=ARG", "客户端名称。"],
      ["", "client-access-token=ARG", "客户端Access Token。"],
      ["h", "help", "display this help"],
    ]) // create Getopt instance
    .bindHelp() // bind option 'help' to default action
    .parseSystem(); // parse command line
  
  var config = require("./config");
  if (opt.options.server) {
    config.server.mailServer = opt.options["server-mail-config"];
    server_main(config)
  } else if (opt.options.client) {
    if (
      !opt.options["client-server-endpoint"] ||
      !opt.options["client-name"] ||
      !opt.options["client-mail-to"] ||
      !opt.options["client-access-token"]
    ) {
      throw new Error("客户端启动参数不完整。")
    }
    config.client.serverEndpoint = opt.options["client-server-endpoint"];
    config.client.clientName = opt.options["client-name"];
    config.client.mailTo = opt.options["client-mail-to"];
    config.client.accessToken = opt.options["client-access-token"]
    client_main(config);
  } else {
    throw new Error("必须指定启动方式。");
  }
}

main();
