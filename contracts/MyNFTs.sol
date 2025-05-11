// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/access/Ownable.sol"; // 可选，但推荐用于管理权限

// 我们继承 ERC721PresetMinterPauserAutoId，它已经包含了 ERC721, ERC721Enumerable, MinterRole, PauserRole
// Ownable 将使部署者成为合约的 owner，可以管理角色等
contract MyNFTs is ERC721PresetMinterPauserAutoId, Ownable {
    // 构造函数
    // name: NFT 集合的名称
    // symbol: NFT 集合的符号
    // baseTokenURI: 可选的基础 URI，token ID 会附加到其后形成完整的 tokenURI。
    //                 例如，如果 baseURI 是 "ipfs://MyCollection/"，token ID 是 1，则 tokenURI(1) 将是 "ipfs://MyCollection/1"
    //                 对于 ERC721PresetMinterPauserAutoId，它期望 baseURI 后不带 tokenId，
    //                 它会在内部处理 baseURI + tokenId.toString()
    constructor(
        string memory name,
        string memory symbol,
        string memory baseTokenURI
    ) ERC721PresetMinterPauserAutoId(name, symbol, baseTokenURI) {
        // 将部署者设为合约的 owner (来自 Ownable)
        _transferOwnership(msg.sender);

        // 授予部署者 MINTER_ROLE 和 PAUSER_ROLE 角色
        // 这些角色由 ERC721PresetMinterPauserAutoId 定义
        _setupRole(MINTER_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
    }

    // 可选: 如果不想使用预设的 baseURI + tokenId 模式，
    // 或者想为每个 token 单独设置 tokenURI，可以重写 _baseURI() 或 tokenURI()
    // 例如，重写 tokenURI 来直接返回传入的 URI (这需要修改 mint 函数以接受 tokenURI)
    // 如果使用 ERC721URIStorage，则可以更灵活地为每个 token 设置不同的 URI

    // 为了保持简单，我们将使用 ERC721PresetMinterPauserAutoId 的默认 baseURI + tokenId 行为
    // 但如果你想更灵活地控制每个 NFT 的 URI，可以这样做：
    // (这需要你从 ERC721 和 ERC721URIStorage 继承，而不是用预设)
    /*
    mapping(uint256 => string) private _tokenURIs;

    function mintNFT(address recipient, string memory tokenURIValue) public onlyRole(MINTER_ROLE) returns (uint256) {
        _tokenIdCounter.increment();
        uint256 newItemId = _tokenIdCounter.current();
        _safeMint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURIValue); // ERC721URIStorage 提供
        return newItemId;
    }

    // 重写 tokenURI 函数以返回我们存储的 URI
    function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory _uri = _tokenURIs[tokenId];
        return _uri;
    }
    */

    // 对于 ERC721PresetMinterPauserAutoId，它有一个 mint 函数，但它不接受 tokenURI 参数，
    // 因为它使用 baseURI + tokenId 的模式。
    // 它的 mint 函数签名是：mint(address to) public virtual whenNotPaused onlyRole(MINTER_ROLE)
    // 如果你想在 mint 时就指定独特的元数据，你需要不使用这个预设，而是组合 ERC721 和 ERC721URIStorage。

    // 为了简单起见，我们先用预设。这意味着所有 NFT 会共享一个 baseURI，
    // 只是 tokenId 不同。例如，如果 baseURI 是 "https://myapi.com/nft/"，
    // 则 token #1 的 URI 是 "https://myapi.com/nft/1", token #2 是 "https://myapi.com/nft/2"。
    // 你需要确保你的 API 或 IPFS 文件夹结构能响应这些 URI 并返回正确的 JSON 元数据。
}