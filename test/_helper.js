process.env.NODE_ENV = 'test';
process.env.PORT = '3001';

require('coffee-script/register');
require(__dirname + '/assert-extra');