// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


//    _____      _____    _________________________________________  __________.____       _____    _________________________________________ 
//   /     \    /  _  \  /   _____/\__    ___/\_   _____/\______   \ \______   \    |     /  _  \  /   _____/\__    ___/\_   _____/\______   \
//  /  \ /  \  /  /_\  \ \_____  \   |    |    |    __)_  |       _/  |    |  _/    |    /  /_\  \ \_____  \   |    |    |    __)_  |       _/
// /    Y    \/    |    \/        \  |    |    |        \ |    |   \  |    |   \    |___/    |    \/        \  |    |    |        \ |    |   \
// \____|__  /\____|__  /_______  /  |____|   /_______  / |____|_  /  |______  /_______ \____|__  /_______  /  |____|   /_______  / |____|_  /
//         \/         \/        \/                    \/         \/          \/        \/       \/        \/                    \/         \/ 

// For the masters, by the masters
contract MasterBlaster is ERC20, Ownable(msg.sender) {
    constructor() ERC20("MASTER BLASTER", "MSTR") {
        _mint(msg.sender, 69420000 * (10 ** decimals()));
    }
}

// $MSTR is a meme coin with no intrinsic value or expectation of financial return. There is no formal team or roadmap. 
// It is only for true master blasters.
// The coin is completely useless and for entertainment purposes only.