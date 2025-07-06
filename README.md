
# Azure 3-Tier Architecture with Terraform

This project provisions a **3-tier architecture** on Microsoft Azure using modular Terraform code. It includes:

- One Resource Group
- One Virtual Network with 3 subnets: Web, App, and DB
- One NSG per subnet with specific rules
- Linux Virtual Machines in each tier (Web VM has public IP for SSH access)

---

## 📐 Architecture Diagram

![Azure 3-Tier Architecture](./images/azure-3tier-architecture.png)

> The diagram above shows:
> - Segregated Web, App, and DB subnets inside a VNet
> - NSGs assigned to each subnet
> - Public IP on the Web tier only

---

## 📁 Project Structure

```
azure-3tier-modular/
├── main.tf
├── variables.tf
├── terraform.tfvars
├── README.md
├── images/
│   └── azure-3tier-architecture.png
└── modules/
    ├── network/
    │   ├── main.tf
    │   └── variables.tf
    ├── nsg/
    │   ├── main.tf
    │   └── variables.tf
    └── compute/
        ├── main.tf
        └── variables.tf
```

---

## 🚀 How to Use

### 1. Prerequisites

- Azure CLI authenticated (`az login`)
- Terraform installed (`>=1.0`)
- Sufficient permissions to create resources in Azure

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review the Plan

```bash
terraform plan
```

### 4. Apply the Configuration

```bash
terraform apply
```

---

## 🔐 NSG Rules

Each tier has its own Network Security Group:

- **Web NSG**: Allows HTTP (port 80) and SSH (port 22)
- **App NSG**: Allows HTTPS (port 443) from Web subnet
- **DB NSG**: Allows SQL Server traffic (port 1433) from App subnet

---

## 📦 VM Configuration

- All VMs are Ubuntu-based (`18.04-LTS`)
- Web VM has a public IP and is SSH-accessible
- App and DB VMs are private

---

## 🖼️ Example Terraform Apply Output

```
azurerm_virtual_network.vnet: Creating...
azurerm_subnet.subnet["web"]: Creating...
azurerm_linux_virtual_machine.vm["web"]: Creating...
...
Apply complete! Resources: 12 added, 0 changed, 0 destroyed.
```

---

## ✏️ Customization

You can update:

- `terraform.tfvars` to change region, subnet CIDRs, VM sizes, credentials
- NSG rules to adjust access between tiers

---

## 📄 License

This project is licensed under the MIT License.
