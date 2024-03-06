import { ethers } from 'hardhat';
import MockERC20 from "../artifacts/@openzeppelin/contracts/token/ERC20/IERC20.sol/IERC20.json";
import chains from '../chains.json'

async function main() {

    const privateKey = process.env.PRIVATE_KEY;

    if (!privateKey) throw new Error("Invalid private key. Make sure the PRIVATE_KEY environment variable is set.")

    const gameInterchain = await ethers.deployContract('InterchainGaming', [chains[1].gateway, chains[1].gasService]);

    const wallet = new ethers.Wallet(privateKey);
    const connectedWallet = wallet.connect(ethers.provider);

    if (!chains[1].aUSDC) throw new Error('aUSDC not found')

    const aUSDC = new ethers.Contract(
        chains[1].aUSDC,
        MockERC20.abi,
        connectedWallet
    );

    await aUSDC.approve(gameInterchain.target, 10e18.toString());

    console.log(`fantom contract address: ${gameInterchain.target}`);

}


main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
