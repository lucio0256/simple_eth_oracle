import { ethers } from "ethers"
import abiOracle  from "../artifacts/contracts/Oracle.sol/Oracle.json" with { type: "json" };
import abiConsumer  from "../artifacts/contracts/Consumer.sol/Consumer.json" with { type: "json" };

const provider = new ethers.JsonRpcProvider("http://localhost:8545")
const signer = await provider.getSigner()


const oracle = new ethers.Contract("0x5FbDB2315678afecb367f032d93F642f64180aa3", abiOracle.abi, signer)
const consumer = new ethers.Contract("0x5FbDB2315678afecb367f032d93F642f64180aa3", abiConsumer.abi, signer)


async function handleNewRequest(event) {
    console.log("New event", event)
    const price = ethers.parseUnits(await getPrice(), 2)
    const tx = await oracle.setEthPrice(event, price)
}

async function getPrice() {
    const response = await fetch("https://api.binance.com/api/v3/ticker/price?symbol=ETHUSDT")
    const data  = await response.json()
    return data.price
}


async function priceUpdated(event) {
    const price = ethers.formatUnits(event, 2);
    console.log(parseFloat(price))
}


consumer.on("PriceUpdated", priceUpdated)
oracle.on("NewRequest", handleNewRequest)

