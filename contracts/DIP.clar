;; Decentralized Indexing Protocol - Phase 2 (Debugged)
;; Version 2.0 - Enhanced Sharding and Query Processing

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_INVALID_DATA (err u101))
(define-constant ERR_INSUFFICIENT_STAKE (err u102))
(define-constant ERR_INVALID_SHARD (err u103))
(define-constant ERR_NODE_NOT_FOUND (err u104))
(define-constant MIN_STAKE_AMOUNT u1000)

;; Data Variables
(define-data-var protocol-enabled bool true)
(define-data-var total-shards uint u0)
(define-data-var total-nodes uint u0)

;; Define buffer types for lists
(define-data-var empty-uint-list (list 10 uint) (list ))
(define-data-var empty-string-list (list 5 (string-ascii 32)) (list ))

;; Enhanced Data Types
(define-map IndexNodes
    { node-id: uint }
    {
        data-type: (string-ascii 64),
        start-time: uint,
        end-time: uint,
        storage-location: (string-ascii 256),
        query-endpoint: (string-ascii 256),
        stake-amount: uint,
        is-active: bool,
        performance-score: uint,
        assigned-shards: (list 10 uint)
    }
)

(define-map Shards
    { shard-id: uint }
    {
        size: uint,
        node-assignments: (list 3 uint),
        data-type: (string-ascii 64),
        time-range-start: uint,
        time-range-end: uint,
        is-sealed: bool
    }
)

;; Enhanced Storage Configuration
(define-map StorageConfigs
    { config-id: uint }
    {
        shard-size: uint,
        redundancy-factor: uint,
        compression-enabled: bool,
        replication-strategy: (string-ascii 32),
        consistency-level: uint
    }
)

;; New Query Processing Structure
(define-map QueryProcessors
    { processor-id: uint }
    {
        node-id: uint,
        supported-ops: (list 5 (string-ascii 32)),
        max-complexity: uint,
        timeout: uint
    }
)

;; Shard Management
(define-public (create-shard 
    (shard-id uint)
    (data-type (string-ascii 64))
    (time-range-start uint)
    (time-range-end uint))
    (let
        (
            (empty-nodes (list ))
        )
        (begin
            (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
            (asserts! (validate-time-range time-range-start time-range-end) ERR_INVALID_DATA)
            (asserts! (is-none (get-shard-info shard-id)) ERR_INVALID_SHARD)
            
            (map-set Shards
                { shard-id: shard-id }
                {
                    size: u0,
                    node-assignments: empty-nodes,
                    data-type: data-type,
                    time-range-start: time-range-start,
                    time-range-end: time-range-end,
                    is-sealed: false
                }
            )
            (var-set total-shards (+ (var-get total-shards) u1))
            (ok true)
        )
    )
)

;; Enhanced Node Registration
(define-public (register-node-v2 
    (node-id uint) 
    (data-type (string-ascii 64))
    (start-time uint)
    (end-time uint)
    (storage-location (string-ascii 256))
    (query-endpoint (string-ascii 256))
    (stake-amount uint))
    (begin
        (asserts! (>= stake-amount MIN_STAKE_AMOUNT) ERR_INSUFFICIENT_STAKE)
        (asserts! (validate-time-range start-time end-time) ERR_INVALID_DATA)
        (asserts! (is-none (get-node-info node-id)) ERR_INVALID_DATA)
        
        (map-set IndexNodes
            { node-id: node-id }
            {
                data-type: data-type,
                start-time: start-time,
                end-time: end-time,
                storage-location: storage-location,
                query-endpoint: query-endpoint,
                stake-amount: stake-amount,
                is-active: true,
                performance-score: u100,
                assigned-shards: (var-get empty-uint-list)
            }
        )
        (var-set total-nodes (+ (var-get total-nodes) u1))
        (ok true)
    )
)

;; Advanced Query Processing
(define-public (register-query-processor 
    (processor-id uint)
    (node-id uint)
    (max-complexity uint)
    (timeout uint))
    (begin
        (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
        (asserts! (node-exists node-id) ERR_NODE_NOT_FOUND)
        
        (map-set QueryProcessors
            { processor-id: processor-id }
            {
                node-id: node-id,
                supported-ops: (var-get empty-string-list),
                max-complexity: max-complexity,
                timeout: timeout
            }
        )
        (ok true)
    )
)

;; Enhanced Storage Configuration
(define-public (configure-storage-v2
    (config-id uint)
    (shard-size uint)
    (redundancy-factor uint)
    (compression-enabled bool)
    (replication-strategy (string-ascii 32))
    (consistency-level uint))
    (begin
        (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
        (asserts! (validate-storage-config shard-size redundancy-factor consistency-level) ERR_INVALID_DATA)
        
        (map-set StorageConfigs
            { config-id: config-id }
            {
                shard-size: shard-size,
                redundancy-factor: redundancy-factor,
                compression-enabled: compression-enabled,
                replication-strategy: replication-strategy,
                consistency-level: consistency-level
            }
        )
        (ok true)
    )
)

;; Helper Functions
(define-private (validate-time-range (start uint) (end uint))
    (and (> end start) (> start u0))
)

(define-private (node-exists (node-id uint))
    (is-some (get-node-info node-id))
)

(define-private (validate-storage-config (shard-size uint) (redundancy-factor uint) (consistency-level uint))
    (and 
        (> shard-size u0)
        (>= redundancy-factor u1)
        (<= consistency-level redundancy-factor)
    )
)

;; Read-Only Functions
(define-read-only (get-shard-info (shard-id uint))
    (map-get? Shards { shard-id: shard-id })
)

(define-read-only (get-node-info (node-id uint))
    (map-get? IndexNodes { node-id: node-id })
)

(define-read-only (get-processor-info (processor-id uint))
    (map-get? QueryProcessors { processor-id: processor-id })
)