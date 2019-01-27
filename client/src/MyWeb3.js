const Web3 = require('web3');

/* can be re-assigned */
let web3; 

/* injecting web3 */
if (typeof window.ethereum !== 'undefined' || typeof window.web3 !== 'undefined') {
    const provider = window['ethereum'] || window.web3.currentProvider;
    web3 = new Web3(provider);
} else {
    const provider = new Web3.providers.HttpProvider('http://127.0.0.1:8545');
    web3 = new Web3(provider);
}


export default web3;


// if (typeof window !== 'undefined' && typeof window.web3 !== 'undefined') {
//     /* in browser with injected web3 (metamask) => overwrite web3 */
//     web3 = new Web3(window.web3.currentProvider);
// } else {
//     /* on a server || no injected web3 */
//     const provider = new Web3.providers.HttpProvider('http://127.0.0.1:8545');
//     web3 = new Web3(provider);
// }
