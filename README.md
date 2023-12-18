![admanager-banner](https://github.com/venis-majkofci/AdManager/assets/95318781/93bae0e4-88d0-4c18-bc90-94c9cba07d7e)

<div align="center">

<!--[![GitHub release](https://img.shields.io/github/v/release/venis-majkofci/AdManager)](https://github.com/venis-majkofci/AdManager/releases/latest)-->
  
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
![Downloads](https://img.shields.io/packagist/dt/venis-majkofci/AdManager)
[![GitHub stars](https://img.shields.io/github/stars/venis-majkofci/AdManager)](https://github.com/venis-majkofci/AdManager/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/venis-majkofci/AdManager)](https://github.com/venis-majkofci/AdManager/issues)
[![Built with PowerShell](https://img.shields.io/badge/Built%20with-PowerShell-blue)](https://www.electronjs.org/)
[![Buy Me A Coffee](https://img.shields.io/badge/Support-Buy%20Me%20A%20Coffee-orange)](https://www.buymeacoffee.com/venis)
</div>

This program is designed to facilitate Active Directory management by creating organizational units, groups, and users based on a setup configuration defined in a json file. Additionally, user information can also be sourced from CSV files and linked tu the setup file.

---

### Prerequisites

- **PowerShell**: Ensure PowerShell is installed on your system.
- **Active Directory Module**: Import the Active Directory module to execute Active Directory cmdlets.

### Configuration

1. **Setup Configuration (`domain_setup.json`)**: Define the structure for creating organizational units, groups, and users. Example:

    ```json
    {
        "domain": {
            "name": "dom",
            "extension": "com"
        },
        "organizationalUnits": [
            {
                "name": "OU1",
                "protectAccidentalDeletion": true,
                "description": "Description of OU1",
                "groups": [
                    {
                        "name": "Group1",
                        "samAccountName": "group1",
                        "displayName": "Group 1",
                        "groupScope": "Global",
                        "groupType": "Security",
                        "description": "Description of Group1",
                        "memberOf": [],
                        "membersOptions": {
                            "useCSV": false,
                            "members": [
                                {
                                    "firstName": "User1",
                                    "lastName": "",
                                    "fullName": "User1",
                                    "initials": "U1",
                                    "samAccountName": "user1",
                                    "displayName": "User 1",
                                    "logonName": "user1",
                                    "password": "P4sswor1d!!!",
                                    "description": "Description of User1",
                                    "enabled": true,
                                    "changePasswordAtLogon": false,
                                    "cannotChangePassword": true,
                                    "passwordNeverExpires": true
                                }
                            ]
                        }
                    },
                    {
                        "name": "Group2",
                        "samAccountName": "group2",
                        "displayName": "Group 2",
                        "groupScope": "Global",
                        "groupType": "Security",
                        "description": "Description of Group2",
                        "memberOf": [],
                        "membersOptions": {
                            "useCSV": true,
                            "scvPath": "./data/users.csv"
                        }
                    }
                ]
            }
        ]
    }
    ```

2. **User CSV File example**:
   
   The default delimiter is `;` 
      | firstName | lastName | fullName | initials | samAccountName | displayName | logonName | password     | description | enabled | changePasswordAtLogon | cannotChangePassword | passwordNeverExpires |
    |-----------|----------|----------|----------|----------------|-------------|-----------|--------------|-------------|---------|----------------------|----------------------|----------------------|
    | User2     |          | User2    | U2       | user2          | User 2      | user2     | P4sswor1d!!! | Description of User2 | True    | False                | False                | True                 |

### Usage

1. **Run the Script**: Execute the main PowerShell script `main.ps1`.
   
    ```powershell
    .\main.ps1
    ```
2. **View Logs**: Logs will be generated during the process, providing insights into successful or failed operations.

## Notes

- **Error Handling**: The script incorporates error handling to manage and log any encountered errors during the Active Directory management process.
- **Logging**: Logging functionality records all operations, allowing for review and troubleshooting post-execution.


## Contributing

Contributions are welcome! If you'd like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes.
4. Test your changes thoroughly.
5. Submit a pull request explaining the changes you made.

## Support

If you find this project helpful, you can support its development by buying me a coffee:

[![Buy Me A Coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/venis)


## License

This project is licensed under the [Apache-2.0 license](LICENSE).
