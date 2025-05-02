// SPDX-License-Identifier: UNLICENSED
// © 2025 Better2Better Tech - All Rights Reserved
// This smart contract was developed by Better2Better for the GIC Auto X project.
// Unauthorized use, copying, or distribution is strictly prohibited.
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20Token is ERC20, ERC20Pausable, Ownable {
    bool public mintingAllowed = true;
    mapping(address => bool) private blacklist;
    mapping(address => bool) private admins;
    address[] private adminList;

    string private website;
    string[] private socialLinks;

    // --- Events ---
    event MintingDisabled();
    event WebsiteUpdated(string website);
    event WebsiteRemoved();
    event SocialLinkAdded(string link);
    event SocialLinkRemoved(uint index, string removedLink);
    event Blacklisted(address indexed user);
    event RemovedFromBlacklist(address indexed user);
    event AdminAdded(address indexed admin);
    event AdminRemoved(address indexed admin);

    // --- Modifiers ---
    modifier onlyAdminOrOwner() {
        require(admins[msg.sender] || msg.sender == owner(), "Only admin or owner");
        _;
    }

    modifier notBlacklisted(address user) {
        require(!blacklist[user], "Address is blacklisted");
        _;
    }

    // --- Constructor --- 
    constructor(uint256 initialSupply) ERC20("GIC Auto X Token", "GATX") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply * 10 ** decimals());
        admins[msg.sender] = true;
        adminList.push(msg.sender);
    }

    // --- _update Override ---
    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Pausable) {
        require(!blacklist[from] && !blacklist[to], "Blacklisted address");
        super._update(from, to, value);
    }

    // --- Funções modificadas para verificação de blacklist ---
    function approve(address spender, uint256 amount) public override notBlacklisted(msg.sender) returns (bool) {
        return super.approve(spender, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public override notBlacklisted(msg.sender) returns (bool) {
        return super.transferFrom(from, to, amount);
    }

    // --- Mint ---
    function mint(address to, uint256 amount) public onlyAdminOrOwner whenNotPaused notBlacklisted(to) {
        require(mintingAllowed, "Minting is disabled");
        _mint(to, amount * 10 ** decimals());
    }

    function disableMinting() public onlyAdminOrOwner {
        mintingAllowed = false;
        emit MintingDisabled();
    }

    // --- Admin Management ---
    function setAdmin(address admin) public onlyOwner {
        require(!admins[admin], "Already admin");
        admins[admin] = true;
        adminList.push(admin);
        emit AdminAdded(admin);
    }

    function removeAdmin(address admin) public onlyOwner {
        require(admins[admin], "Not an admin");
        admins[admin] = false;
        for (uint i = 0; i < adminList.length; i++) {
            if (adminList[i] == admin) {
                adminList[i] = adminList[adminList.length - 1];
                adminList.pop();
                break;
            }
        }
        emit AdminRemoved(admin);
    }

    function isAdmin(address addr) public view returns (bool) {
        return admins[addr];
    }

    function getAdmins() public view returns (address[] memory) {
        return adminList;
    }

    // --- Website & Socials ---
    function setWebsite(string memory newWebsite) public onlyAdminOrOwner {
        website = newWebsite;
        emit WebsiteUpdated(newWebsite);
    }

    function removeWebsite() public onlyAdminOrOwner {
        website = "";
        emit WebsiteRemoved();
    }

    function getWebsite() public view returns (string memory) {
        return website;
    }

    function addSocialLink(string memory newLink) public onlyAdminOrOwner {
        socialLinks.push(newLink);
        emit SocialLinkAdded(newLink);
    }

    function removeSocialLink(uint index) public onlyAdminOrOwner {
        require(index < socialLinks.length, "Invalid index");
        string memory removed = socialLinks[index];
        socialLinks[index] = socialLinks[socialLinks.length - 1];
        socialLinks.pop();
        emit SocialLinkRemoved(index, removed);
    }

    function getSocialLinks() public view returns (string[] memory) {
        return socialLinks;
    }

    // --- Blacklist ---
    function setBlacklist(address user) public onlyAdminOrOwner {
        blacklist[user] = true;
        emit Blacklisted(user);
    }

    function removeBlacklist(address user) public onlyAdminOrOwner {
        blacklist[user] = false;
        emit RemovedFromBlacklist(user);
    }

    function isBlacklisted(address user) public view returns (bool) {
        return blacklist[user];
    }

    // --- Pause ---
    function pause() public onlyAdminOrOwner {
        _pause();
    }

    function unpause() public onlyAdminOrOwner {
        _unpause();
    }

    // --- About ---
    function about() public pure returns (
        string memory company,
        string memory project,
        string memory purpose
    ) {
        company = "GIC Sports";
        project = "GIC Auto X";
        purpose = "Utility token developed for the GIC Auto X ecosystem, including mobility, logistics and DeFi applications.";
    }

    // --- PoweredBy ---
    function poweredBy() public pure returns (string memory) {
        return "https://better2better.tech";
    }
}
