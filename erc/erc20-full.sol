// SPDX-License-Identifier: UNLICENSED
// © 2025 Better2Better Tech - All Rights Reserved
// This smart contract was developed by Better2Better for the GIC Auto X project.
// Unauthorized use, copying, or distribution is strictly prohibited.
pragma solidity ^0.8.0;

contract ERC20Token {
    string public constant name = "Token";
    string public constant symbol = "TKN";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;

    address public owner;
    bool public paused = false;
    bool public mintingAllowed = true;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowed;
    mapping(address => bool) private admins;
    mapping(address => bool) private blacklist;

    string private website;
    string[] private socialLinks;

    // --- Events ---
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed burner, uint256 value);
    event Mint(address indexed to, uint256 value);
    event AdminChanged(address indexed admin, bool status);
    event MintingDisabled();
    event WebsiteUpdated(string website);
    event WebsiteRemoved();
    event SocialLinkAdded(string link);
    event SocialLinkRemoved(uint index, string removedLink);
    event Paused();
    event Unpaused();
    event Blacklisted(address indexed user);
    event RemovedFromBlacklist(address indexed user);

    // --- Modifiers ---
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier onlyAdminOrOwner() {
        require(admins[msg.sender] || msg.sender == owner, "Only admin or owner");
        _;
    }

    modifier onlyAdmin() {
        require(admins[msg.sender], "Only admin");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Token is paused");
        _;
    }

    modifier notBlacklisted(address user) {
        require(!blacklist[user], "Address is blacklisted");
        _;
    }

    // --- Constructor ---
    constructor(uint256 initialSupply) {
        owner = msg.sender;
        admins[msg.sender] = true;
        uint256 supply = initialSupply * 10 ** uint256(decimals);
        totalSupply = supply;
        balances[msg.sender] = supply;
    }

    // --- ERC20 Functions ---
    function transfer(address to, uint256 value)
        public
        whenNotPaused
        notBlacklisted(msg.sender)
        notBlacklisted(to)
        returns (bool)
    {
        require(balances[msg.sender] >= value, "Insufficient balance");
        balances[msg.sender] -= value;
        balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value)
        public
        whenNotPaused
        notBlacklisted(msg.sender)
        notBlacklisted(from)
        notBlacklisted(to)
        returns (bool)
    {
        require(balances[from] >= value, "Insufficient balance");
        require(allowed[from][msg.sender] >= value, "Allowance exceeded");
        balances[from] -= value;
        allowed[from][msg.sender] -= value;
        balances[to] += value;
        emit Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint256 value)
        public
        whenNotPaused
        notBlacklisted(msg.sender)
        notBlacklisted(spender)
        returns (bool)
    {
        allowed[msg.sender][spender] = value;
        return true;
    }

    function allowance(address owner_, address spender) public view returns (uint256) {
        return allowed[owner_][spender];
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    // --- Burn ---
    function burn(uint256 value)
        public
        whenNotPaused
        notBlacklisted(msg.sender)
    {
        require(balances[msg.sender] >= value, "Insufficient balance");
        balances[msg.sender] -= value;
        totalSupply -= value;
        emit Burn(msg.sender, value);
    }

    // --- Mint ---
    function mint(address to, uint256 amount)
        public
        onlyAdminOrOwner
        whenNotPaused
        notBlacklisted(to)
    {
        require(mintingAllowed, "Minting is disabled");
        uint256 mintAmount = amount * 10 ** uint256(decimals);
        balances[to] += mintAmount;
        totalSupply += mintAmount;
        emit Mint(to, mintAmount);
    }

    function disableMinting() public onlyAdminOrOwner {
        mintingAllowed = false;
        emit MintingDisabled();
    }

    // --- Admin Management ---
    function setAdmin(address admin) public onlyOwner {
        admins[admin] = true;
        emit AdminChanged(admin, true);
    }

    function removeAdmin(address admin) public onlyOwner {
        admins[admin] = false;
        emit AdminChanged(admin, false);
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
        for (uint i = index; i < socialLinks.length - 1; i++) {
            socialLinks[i] = socialLinks[i + 1];
        }
        socialLinks.pop();
        emit SocialLinkRemoved(index, removed);
    }

    function getSocialLinks() public view returns (string[] memory) {
        return socialLinks;
    }

    // --- Blacklist ---
    function setBlacklist(address user) public onlyAdmin {
        blacklist[user] = true;
        emit Blacklisted(user);
    }

    function removeBlacklist(address user) public onlyAdmin {
        blacklist[user] = false;
        emit RemovedFromBlacklist(user);
    }

    function isBlacklisted(address user) public view returns (bool) {
        return blacklist[user];
    }

    // --- Pause ---
    function pause() public onlyAdmin {
        paused = true;
        emit Paused();
    }

    function unpause() public onlyAdmin {
        paused = false;
        emit Unpaused();
    }

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
