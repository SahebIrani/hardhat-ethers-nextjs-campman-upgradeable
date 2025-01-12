// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import './FactoryModifiers.sol';
import './FactoryLogics.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';

contract Factory is Initializable, FactoryModifiers, FactoryLogics {
    function initialize() public initializer {
        factoryStatus.owner = payable(msg.sender);
        factoryStatus.tax = 0.01 * 10**18;
        factoryStatus.maxNameLength = 32;
        factoryStatus.maxDescriptionLength = 255;
        factoryStatus.maxContributionPeriod = 6;
    }

    fallback() external payable {}

    receive() external payable {}

    function Pause() external notPaused onlyOwner {
        _Pause();
    }

    function unPause() external onlyOwner {
        _unPause();
    }

    function setTax(uint64 _tax) external onlyOwner {
        _setTax(_tax);
    }

    function authorize(address _authorizedAddress) external onlyOwner {
        _authorize(_authorizedAddress);
    }

    function blacklist(address _blacklistedAddress) external onlyOwner {
        _blacklist(_blacklistedAddress);
    }

    function createCampaign(
        bytes32 _name,
        string memory _description,
        string memory _banner,
        uint256 _minimum,
        uint256 _contributionPeriod
    ) external payable notPaused authorized(msg.sender) notBlacklisted(msg.sender) checkInputsCreateCampaign(_name, _description, _minimum, _contributionPeriod) {
        _createCampaign(_name, _description, _banner, _minimum, _contributionPeriod);
    }

    function getCampaigns() external view override returns (address[] memory) {
        return _getCampaigns();
    }

    function rejectCampaign(address rejectedAddress) external onlyOwner {
        _rejectCampaign(rejectedAddress);
    }

    function withdrawTaxFees() external onlyOwner {
        _withdrawTaxFees();
    }
}
