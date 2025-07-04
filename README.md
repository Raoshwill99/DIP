# Decentralized Indexing Protocol (DIP) v3.0

## Overview

The Decentralized Indexing Protocol (DIP) provides a scalable solution for managing and querying distributed data indexes across a network of nodes. This protocol implements sharded data storage, distributed query processing, and an incentivized node participation system with performance-based rewards.

## Features

### Core Features
- **Sharded Data Storage**: Optimized data distribution across network nodes with dedicated shard management
- **Stake-Based Node Participation**: Economic incentives for node operators with minimum stake requirements
- **Query Processing System**: Fee-based distributed query handling with automatic reward distribution
- **Performance Monitoring**: Real-time node performance tracking and scoring
- **Reward System**: Automatic reward calculation and distribution to active nodes

### Enhanced Features (Phase 3)
- **Compact Architecture**: Streamlined contract design focusing on essential features
- **Advanced Node Management**: Comprehensive node registration and lifecycle management
- **Fee-Based Query Processing**: Configurable query fees with complexity-based pricing
- **Real-Time Rewards**: Immediate reward distribution upon query completion
- **Administrative Controls**: Owner-controlled node management and performance updates

## Technical Architecture

### Core Components

1. **IndexNodes**
   - Node identification and management
   - Query endpoint registration
   - Stake management and validation
   - Performance scoring (0-100 scale)
   - Query processing statistics
   - Reward tracking and distribution
   - Active/inactive status management

2. **Shards**
   - Node assignment tracking (up to 3 nodes per shard)
   - Data type specification
   - Query volume monitoring
   - Sealing status management

3. **Query Processing**
   - Fee-based query execution
   - Automatic reward distribution
   - Query record tracking
   - Performance impact monitoring

4. **Reward System**
   - Pending rewards accumulation
   - Claim mechanism for node operators
   - Total earnings tracking
   - Performance-based reward adjustment

## Smart Contract Interface

### Principal Functions

#### Node Management
```clarity
;; Register a new indexing node
(define-public (register-node 
    (node-id uint) 
    (query-endpoint (string-ascii 256))
    (stake-amount uint))
)

;; Deactivate a node (admin only)
(define-public (deactivate-node (node-id uint))
)

;; Update node performance score (admin only)
(define-public (update-performance (node-id uint) (new-score uint))
)
```

#### Shard Management
```clarity
;; Create a new data shard
(define-public (create-shard 
    (shard-id uint)
    (data-type (string-ascii 64))
    (node-assignments (list 3 uint)))
)
```

#### Query Processing
```clarity
;; Execute a query with fee payment
(define-public (execute-query
    (query-id uint)
    (node-id uint)
    (fee-amount uint))
)

;; Calculate query fee based on complexity
(define-read-only (calculate-query-fee (complexity uint))
)
```

#### Reward Management
```clarity
;; Claim accumulated rewards
(define-public (claim-rewards (node-id uint))
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
| MIN_STAKE_AMOUNT | Minimum required stake for node registration | 1000 | ≥ 1000 |
| BASE_QUERY_FEE | Base fee for query execution | 10 | > 0 |
| Performance Score | Node performance rating | 100 (initial) | 0-100 |
| Shard Node Limit | Maximum nodes per shard | 3 | Fixed |

## Error Handling

### Error Codes
- **ERR_UNAUTHORIZED (u100)**: Unauthorized access attempt
- **ERR_INVALID_DATA (u101)**: Invalid data provided
- **ERR_INSUFFICIENT_STAKE (u102)**: Stake amount below minimum requirement
- **ERR_NODE_NOT_FOUND (u104)**: Specified node does not exist
- **ERR_INSUFFICIENT_BALANCE (u105)**: Insufficient balance for operation

### Validation Checks
- Minimum stake requirement validation
- Node existence verification
- Fee amount validation
- Performance score bounds checking
- Active node status verification

## Usage Examples

### 1. Register a Node
```clarity
(contract-call? .decentralized-indexing-protocol register-node 
    u1 
    "https://api.mynode.com/query" 
    u1500)
```

### 2. Create a Shard
```clarity
(contract-call? .decentralized-indexing-protocol create-shard 
    u1 
    "web-pages" 
    (list u1 u2 u3))
```

### 3. Execute a Query
```clarity
(contract-call? .decentralized-indexing-protocol execute-query 
    u1001 
    u1 
    u15)
```

### 4. Claim Rewards
```clarity
(contract-call? .decentralized-indexing-protocol claim-rewards u1)
```

### 5. Check Node Information
```clarity
(contract-call? .decentralized-indexing-protocol get-node-info u1)
```

## Testing

### Unit Tests
```bash
clarinet test tests/unit/*
```

### Integration Tests
```bash
clarinet test tests/integration/*
```

### Test Coverage Areas
- Node registration with various stake amounts
- Query execution with valid and invalid fees
- Reward claiming and distribution
- Performance score updates
- Administrative functions
- Error handling scenarios

## Project Roadmap

### Phase 1 (Completed)
- Basic indexing functionality
- Node registration system
- Simple sharding implementation

### Phase 2 (Completed)
- Advanced sharding system with dedicated management
- Performance-based node scoring
- Enhanced query processing infrastructure
- Improved storage configuration with replication strategies

### Phase 3 (Current - Compact Version)
- Streamlined contract architecture
- Essential features focus
- Fee-based query processing
- Real-time reward distribution
- Administrative controls
- Performance monitoring

### Future Phases
- Advanced incentive mechanisms
- Cross-shard query optimization
- Dynamic node rebalancing
- Enhanced security features
- Advanced data validation
- Multi-chain support

## Debugging and Troubleshooting

### Common Issues

1. **Node Registration Failures**
   - Verify stake amount meets minimum requirement (≥ 1000)
   - Ensure unique node ID
   - Check query endpoint format

2. **Query Execution Errors**
   - Verify node exists and is active
   - Check fee amount meets minimum requirement
   - Ensure node ID is valid

3. **Reward Claiming Issues**
   - Verify node has pending rewards
   - Check node ownership
   - Ensure node is registered

### Monitoring and Analytics
- Track total nodes and queries via `get-protocol-stats`
- Monitor node performance scores
- Track reward distributions
- Analyze query patterns

## Security Considerations

- **Admin Controls**: Only contract owner can create shards and manage node performance
- **Stake Requirements**: Minimum stake ensures node commitment
- **Fee Validation**: Automatic fee verification prevents underpayment
- **Performance Tracking**: Ongoing monitoring enables quality control
- **Reward Protection**: Secure reward distribution mechanism

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
- Maintain backward compatibility

## API Reference

### Read-Only Functions

| Function | Description | Parameters | Returns |
|----------|-------------|------------|---------|
| `get-node-info` | Retrieve node information | `node-id` | Node details or none |
| `get-shard-info` | Get shard information | `shard-id` | Shard details or none |
| `get-query-record` | Fetch query record | `query-id` | Query details or none |
| `get-node-rewards` | Check node rewards | `node-id` | Reward information or none |
| `get-protocol-stats` | Get protocol statistics | None | Total nodes/queries/status |
| `calculate-query-fee` | Calculate query fee | `complexity` | Calculated fee amount |

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Version:** 3.0 (Compact)  
**Network:** Stacks Blockchain  
**Language:** Clarity  
**Contract Owner:** Raoshwill99
