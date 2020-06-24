const { Router } = require("express");
const fs = require('fs');
const consola = require('consola');
const nodemailer = require("nodemailer");

const secrets = require('./_config/secrets');

const ip_list = '_config/ip_list.json';

const notifier_controller = function (config) {
  const router = Router();
  router.post('/api/notifier', function (req, res, next) {
    var auth = req.header("Authorization");
    if (!auth) {
      res.statusCode = 401;
      res.end();
    }
    var token = auth.substr(7);
    if (!token || !secrets.authorization.tokens.some((m) => m === token)) {
      res.statusCode = 401;
      res.end();
    }

    if (!fs.existsSync(ip_list)) {
      fs.writeFileSync(ip_list, '{}');
    }
    let map = JSON.parse(
      fs.readFileSync(ip_list, { encoding: 'utf-8' })
    );
    const reqJson = req.body;
    let prevIP;
    for (var i in map) {
      if (i === reqJson.clientName) {
        prevIP = map[i];
        break;
      }
    }
    if (!prevIP || prevIP !== req.ip) {
      const mailServer = secrets.mailServers[config.server.mailServer];
      const transporter = nodemailer.createTransport(mailServer.config);

      const mailOptions = {
        from: mailServer.address,
        to: reqJson.mailTo,
        subject: "New IP for " + reqJson.clientName,
        text: req.ip,
      };

      transporter.sendMail(mailOptions, function(error, info){
        if (error) {
          consola.error(error);
          res.status(500).send(error).end();
        } else {
          consola.success("Email sent: " + info.response);
          map[prevIP] = req.ip;
          fs.writeFileSync(ip_list, JSON.stringify(map));
          res.statusCode = 203;
          res.end();
        }
      });
    }
  });
  return router;
};

module.exports = function (config) {
  const router = Router();
  router.use(notifier_controller(config));
  return router;
};
