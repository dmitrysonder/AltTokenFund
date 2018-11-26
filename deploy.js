const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const { interface, bytecode } = require('./compile');

const provider = new HDWalletProvider(
	'recycle dash year slim prison twenty angle parade mouse rack adult method',
	'https://rinkeby.infura.io/w7sXwXV3GmYH938ht480'
);

const web3 = new Web3(provider);

const deploy = async () => {
	const accounts = await web3.eth.getAccounts();

	console.log('Attempting to deploy from account', accounts[0]);

	const result = await new web3.eth.Contract(JSON.parse(interface))
		.deploy({ data: bytecode, arguments: ['0xF72bb0De7Bde2f356f5a0Ff48f2D5e281F9195C5']})
		.send({ gas: '1000000', from: accounts[0]});

	console.log('Contract deployed to', result.options.address);
};

deploy();
