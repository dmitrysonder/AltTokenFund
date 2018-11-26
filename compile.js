const path = require('path');
const fs = require('fs');
const solc = require('solc');

const FundPath = path.resolve(__dirname, 'contracts', 'Fund.sol');
const source = fs.readFileSync(FundPath, 'utf8');

console.log(solc.compile(source, 1).contracts)

module.exports = solc.compile(source, 1).contracts[':Fund']
