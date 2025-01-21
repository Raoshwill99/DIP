# Decentralized Indexing Protocol

A robust blockchain-based protocol for distributed data indexing built with Clarity smart contracts on the Stacks blockchain.

## Overview

The Decentralized Indexing Protocol (DIP) provides a scalable solution for managing and querying distributed data indexes across a network of nodes. This protocol implements sharded data storage, distributed query processing, and an incentivized node participation system.

## Features

### Core Features
- **Sharded Data Storage**: Optimized data distribution across network nodes
- **Time-Range Based Indexing**: Efficient temporal data organization
- **Stake-Based Node Participation**: Economic incentives for node operators
- **Configurable Storage Parameters**: Flexible sharding and redundancy settings
- **Query Processing System**: Distributed query handling capabilities

### Enhanced Features (Phase 2)
- **Advanced Sharding Management**: Dedicated shard creation and tracking
- **Performance Scoring**: Node performance monitoring and tracking
- **Enhanced Query Processing**: Configurable operation support and complexity management
- **Improved Storage Configuration**: Customizable replication strategies and consistency levels

## Technical Architecture

### Core Components

1. **IndexNodes**
   - Node identification and management
   - Data type specification
   - Time range assignment
   - Storage location tracking
   - Query endpoint registration
   - Stake management
   - Performance scoring
   - Shard assignment tracking

2. **Shards**
   - Size tracking
   - Node assignments
   - Data type specification
   - Time range management
   - Sealing status

3. **Storage Configuration**
   - Shard size configuration
   - Redundancy factor settings
   - Compression options
   - Replication strategy
   - Consistency level management

4. **Query Processors**
   - Operation support tracking
   - Complexity management
   - Timeout configuration

## Error Handling

### Error Codes
- ERR_UNAUTHORIZED (u100): Unauthorized access attempt
- ERR_INVALID_DATA (u101): Invalid data provided
- ERR_INSUFFICIENT_STAKE (u102): Stake amount below minimum
- ERR_INVALID_SHARD (u103): Invalid shard operation
- ERR_NODE_NOT_FOUND (u104): Node not found in system

### Validation Checks
- Time range validation
- Storage configuration validation
- Node existence verification
- Shard availability checking
- Stake requirement verification

## Smart Contract Interface

### Principal Functions

```clarity
;; Node Registration
(define-public (register-node-v2 
    (node-id uint) 
    (data-type (string-ascii 64))
    (start-time uint)
    (end-time uint)
    (storage-location (string-ascii 256))
    (query-endpoint (string-ascii 256))
    (stake-amount uint))
)

;; Shard Management
(define-public (create-shard 
    (shard-id uint)
    (data-type (string-ascii 64))
    (time-range-start uint)
    (time-range-end uint))
)

;; Storage Configuration
(define-public (configure-storage-v2
    (config-id uint)
    (shard-size uint)
    (redundancy-factor uint)
    (compression-enabled bool)
    (replication-strategy (string-ascii 32))
    (consistency-level uint))
)
```

## Setup and Deployment

### Prerequisites

- Stacks blockchain development environment (version 2.0 or higher)
- Clarity CLI tools
- Node.js (v14.0.0 or higher)
- NPM (v6.0.0 or higher)

### Installation

1. Clone the repository:
   ```bash
   git clone [repository-url]
   cd decentralized-indexing-protocol
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Configure environment:
   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

### Development

1. Start local Stacks blockchain:
   ```bash
   clarinet integrate
   ```

2. Deploy contract:
   ```bash
   clarinet deploy
   ```

3. Run tests:
   ```bash
   clarinet test
   ```

## Configuration Parameters

| Parameter | Description | Default Value | Valid Range |
|-----------|-------------|---------------|-------------|
| Shard Size | Size of each data shard | 1000 records | > 0 |
| Redundancy Factor | Number of replica copies | 3 | ≥ 1 |
| Minimum Stake | Required stake amount | 1000 STX | ≥ 1000 |
| Consistency Level | Required consistency level | 2 | ≤ Redundancy Factor |

## Testing

### Unit Tests
```bash
clarinet test tests/unit/*
```

### Integration Tests
```bash
clarinet test tests/integration/*
```

## Project Roadmap

### Phase 1 (Completed)
- Basic indexing functionality
- Node registration system
- Simple sharding implementation

### Phase 2 (Current)
- Advanced sharding system with dedicated management
- Performance-based node scoring
- Enhanced query processing infrastructure
- Improved storage configuration with replication strategies
- Comprehensive error handling and validation
- Debug and optimization improvements

### Future Phases
- Advanced incentive mechanisms
- Cross-shard query optimization
- Dynamic node rebalancing
- Enhanced security features
- Advanced data validation

## Debugging and Troubleshooting

### Common Issues
1. Node Registration Failures
   - Verify stake amount meets minimum requirement
   - Ensure unique node ID
   - Check time range validity

2. Shard Creation Issues
   - Verify shard ID uniqueness
   - Check time range parameters
   - Ensure proper data type specification

3. Query Processing Errors
   - Verify node existence
   - Check operation support
   - Monitor timeout configurations

### Logging and Monitoring
- Contract events for major operations
- Performance metrics tracking
- Error tracking and reporting

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow Clarity best practices
- Include comprehensive tests
- Update documentation
- Add proper error handling

## License

This project is licensed under the MIT License - see the LICENSE file for details.
