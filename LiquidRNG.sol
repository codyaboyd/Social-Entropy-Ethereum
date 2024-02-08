// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;
abstract contract Context {
    function _msgSender() internal view virtual returns(address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns(bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(_msgSender());
    }

    function owner() public view virtual returns(address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

abstract contract Controllable is Ownable {
    mapping(address => bool) internal _controllers;

    modifier onlyController() {
        require(
            _controllers[msg.sender] == true || address(this) == msg.sender,
            "Controllable: caller is not a controller"
        );
        _;
    }

    function addController(address _controller)
    external
    onlyOwner {
        _controllers[_controller] = true;
    }

    function delController(address _controller)
    external
    onlyOwner {
        delete _controllers[_controller];
    }

    function disableController(address _controller)
    external
    onlyOwner {
        _controllers[_controller] = false;
    }

    function isController(address _address)
    external
    view
    returns(bool allowed) {
        allowed = _controllers[_address];
    }

    function relinquishControl() external onlyController {
        delete _controllers[msg.sender];
    }
}

contract LiquidRNG is Controllable {

    uint256 public mod1 = 61846424845862;
    uint256 public modGlob = 561816115460000;
    uint256 private seed1 = 11233298312348491934;
    uint256 private seed2 = 35432124634000488331;
    uint256 private seed3 = 89184172487487112344;
    uint256 private seed4 = 23921124564123553311;
    uint256 private seed5 = 63353123409375849911;
    uint256 public rStep = 23513;
    uint256 private rJump = 972;
    uint256 private extEnt = 12461478643531556351412;
    address private envEnt1 = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
    address private envEnt2 = 0x5b3256965e7C3cF26E11FCAf296DfC8807C01073;
    address private envEnt3 = 0xe7804c37c13166fF0b37F5aE0BB07A3aEbb6e245;

    function random1(uint256 mod, uint256 demod) external view returns(uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, seed1,
            rStep * 2345, envEnt1, envEnt1.balance, msg.sender, extEnt))) % mod + demod;
    }

    function random2(uint256 mod, uint256 demod) external view returns(uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, seed2,
            rStep * 33452, envEnt2, envEnt2.balance, msg.sender, extEnt))) % mod + demod;
    }

    function random3(uint256 mod, uint256 demod) external view returns(uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, seed3,
            rStep * 43466, envEnt3, envEnt3.balance, msg.sender, extEnt))) % mod + demod;
    }

    function random4(uint256 mod, uint256 demod) external view returns(uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, seed4,
            rStep * 5346, envEnt1, envEnt2, envEnt1.balance, envEnt2.balance, msg.sender, extEnt))) % mod + demod;
    }

    function random5(uint256 mod, uint256 demod) external view returns(uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, seed5,
            rStep * 887665, envEnt1, envEnt3, envEnt1.balance, envEnt3.balance, msg.sender, extEnt))) % mod + demod;
    }

    function random6() external view returns(uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, seed1,
            rStep * 600968, envEnt2, envEnt3, envEnt2.balance, envEnt3.balance, msg.sender, extEnt))) % mod1 + 1;
    }

    function random7() external view returns(uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, seed2,
            rStep * 7112344, envEnt1, envEnt2, envEnt3, envEnt1.balance, envEnt2.balance, envEnt3.balance, msg.sender, extEnt))) % mod1 + 1;
    }

    function random8() external view returns(uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, seed3,
            rStep * 8888774, msg.sender, extEnt))) % mod1 + 1;
    }

    function random9() external view returns(uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, seed4,
            rStep * 976876, envEnt1, envEnt1.balance * envEnt2.balance, msg.sender, extEnt))) % mod1 + 1;
    }

    function random10() external view returns(uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, seed5,
            rStep * 4345733, envEnt2, envEnt3.balance * envEnt1.balance, msg.sender, extEnt))) % mod1 + 1;
    }

    function randomFull() external view returns(uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, seed5 + seed1 * seed2,
            rStep * 4345733, envEnt3, envEnt2.balance * envEnt3.balance, msg.sender, extEnt))) % modGlob + 1;
    }

    function requestMixup() external {
        rStep = rStep + rJump;
    }

    function setBaseMods(uint256 newMod) external onlyOwner {
        mod1 = newMod;
    }

    function globalModAndDeMod(uint256 newMod) external onlyOwner {
        modGlob = newMod;
    }

    function seedChange(uint256 NS1, uint256 NS2, uint256 NS3, uint256 NS4, uint256 NS5) external onlyOwner {
        seed1 = NS1;
        seed2 = NS2;
        seed3 = NS3;
        seed4 = NS4;
        seed5 = NS5;
    }

    function resetStepJump(uint256 newStep, uint256 newJump) external onlyOwner {
        rStep = newStep;
        rJump = newJump;
    }

    function setExtEnt(uint256 newExEnt) external onlyController {
        extEnt = newExEnt;
    }
}
