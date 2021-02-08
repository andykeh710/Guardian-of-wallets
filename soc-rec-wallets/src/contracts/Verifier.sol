
import "./ECDSA.sol";
pragma solidity >=0.5.0 <0.8.0;

contract Verifier{
    using ECDSA for bytes32;

    mapping(address => mapping(uint256 => bool)) seenNonces;

    function submitOrder(address owner, uint256 amount, uint256 nonce, bytes memory signature) public {
    // This recreates the message hash that was signed on the client.
    bytes32 hash = keccak256(abi.encodePacked(owner, amount, nonce));
    bytes32 messageHash = hash.toEthSignedMessageHash();

    // Verify that the message's signer is the owner of the order
    address signer = messageHash.recover(signature);
    require(signer == owner);

    require(!seenNonces[signer][nonce]);
    seenNonces[signer][nonce] = true;

    //... process order
    }
}