# Documentation Index

Welcome to the Cloudflare Infrastructure documentation!

## 📚 Quick Navigation

### Getting Started

| Document | Description | When to Read |
|----------|-------------|--------------|
| **[QUICKSTART.md](../QUICKSTART.md)** | 5-minute deployment guide | **START HERE** 🚀 |
| **[GETTING_STARTED.md](../GETTING_STARTED.md)** | Setup overview and summary | After setup |
| **[README.md](../README.md)** | Complete documentation | Reference |

### Architecture & Design

| Document | Description |
|----------|-------------|
| **[STACK_ARCHITECTURE.md](../STACK_ARCHITECTURE.md)** | Architecture diagrams and technical details |
| **[ENVIRONMENTS.md](ENVIRONMENTS.md)** | Detailed comparison of FAT/UAT/PROD |

### Reference

| Document | Description |
|----------|-------------|
| **[SETUP_COMPLETE.md](../SETUP_COMPLETE.md)** | What was created and next steps |

## 🎯 Choose Your Path

### I'm New Here
1. Read [QUICKSTART.md](../QUICKSTART.md)
2. Deploy to FAT environment
3. Come back and read [ENVIRONMENTS.md](ENVIRONMENTS.md)

### I Want to Understand the Architecture
1. Read [STACK_ARCHITECTURE.md](../STACK_ARCHITECTURE.md)
2. Review [ENVIRONMENTS.md](ENVIRONMENTS.md)
3. Check [README.md](../README.md) for details

### I Need a Reference
- Go straight to [README.md](../README.md)

## 🚀 Quick Commands

```bash
# Deploy FAT environment
cd stacks/fat
make init && make apply

# Deploy UAT environment
cd stacks/uat
make init && make apply

# Deploy PROD environment
cd stacks/prod
make init && make plan && make apply
```

---

**Questions?** Start with [QUICKSTART.md](../QUICKSTART.md) and you'll be deploying in minutes!
