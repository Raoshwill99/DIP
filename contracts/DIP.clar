;; Decentralized Indexing Protocol - Phase 3 (Compact)
;; Version 3.0 - Essential Features Only

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_INVALID_DATA (err u101))
(define-constant ERR_INSUFFICIENT_STAKE (err u102))
(define-constant ERR_NODE_NOT_FOUND (err u104))
(define-constant ERR_INSUFFICIENT_BALANCE (err u105))

(define-constant MIN_STAKE_AMOUNT u1000)
(define-constant BASE_QUERY_FEE u10)

;; Data Variables
(define-data-var protocol-enabled bool true)
(define-data-var total-nodes uint u0)
(define-data-var total-queries uint u0)

;; Core Data Maps
(define-map IndexNodes
    { node-id: uint }
    {
        stake-amount: uint,
        query-endpoint: (string-ascii 256),
        performance-score: uint,
        is-active: bool,
        total-queries-processed: uint,
        total-rewards-earned: uint
    }
)

(define-map Shards
    { shard-id: uint }
    {
        node-assignments: (list 3 uint),
        data-type: (string-ascii 64),
        total-queries: uint,
        is-sealed: bool
    }
)

(define-map QueryRecords
    { query-id: uint }
    {
        requester: principal,
        node-id: uint,
        fee-paid: uint,
        timestamp: uint,
        success: bool
    }
)

(define-map NodeRewards
    { node-id: uint }
    {
        total-earned: uint,
        pending-rewards: uint,
        last-claim: uint
    }
)

;; Node Registration
(define-public (register-node 
    (node-id uint) 
    (query-endpoint (string-ascii 256))
    (stake-amount uint))
    (begin
        (asserts! (>= stake-amount MIN_STAKE_AMOUNT) ERR_INSUFFICIENT_STAKE)
        (asserts! (is-none (map-get? IndexNodes { node-id: node-id })) ERR_INVALID_DATA)
        
        (map-set IndexNodes
            { node-id: node-id }
            {
                stake-amount: stake-amount,
                query-endpoint: query-endpoint,
                performance-score: u100,
                is-active: true,
                total-queries-processed: u0,
                total-rewards-earned: u0
            }
        )
        
        (map-set NodeRewards
            { node-id: node-id }
            {
                total-earned: u0,
                pending-rewards: u0,
                last-claim: u0
            }
        )
        
        (var-set total-nodes (+ (var-get total-nodes) u1))
        (ok true)
    )
)

;; Create Shard
(define-public (create-shard 
    (shard-id uint)
    (data-type (string-ascii 64))
    (node-assignments (list 3 uint)))
    (begin
        (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
        (asserts! (is-none (map-get? Shards { shard-id: shard-id })) ERR_INVALID_DATA)
        
        (map-set Shards
            { shard-id: shard-id }
            {
                node-assignments: node-assignments,
                data-type: data-type,
                total-queries: u0,
                is-sealed: false
            }
        )
        (ok true)
    )
)

;; Execute Query with Fee
(define-public (execute-query
    (query-id uint)
    (node-id uint)
    (fee-amount uint))
    (let
        (
            (node-info (unwrap! (map-get? IndexNodes { node-id: node-id }) ERR_NODE_NOT_FOUND))
            (calculated-fee BASE_QUERY_FEE)
        )
        (begin
            (asserts! (get is-active node-info) ERR_INVALID_DATA)
            (asserts! (>= fee-amount calculated-fee) ERR_INSUFFICIENT_BALANCE)
            
            ;; Record query
            (map-set QueryRecords
                { query-id: query-id }
                {
                    requester: tx-sender,
                    node-id: node-id,
                    fee-paid: fee-amount,
                    timestamp: block-height,
                    success: true
                }
            )
            
            ;; Update node stats
            (map-set IndexNodes
                { node-id: node-id }
                (merge node-info { 
                    total-queries-processed: (+ (get total-queries-processed node-info) u1)
                })
            )
            
            ;; Add to pending rewards
            (let
                (
                    (reward-info (unwrap! (map-get? NodeRewards { node-id: node-id }) ERR_NODE_NOT_FOUND))
                )
                (map-set NodeRewards
                    { node-id: node-id }
                    (merge reward-info { 
                        pending-rewards: (+ (get pending-rewards reward-info) fee-amount)
                    })
                )
            )
            
            (var-set total-queries (+ (var-get total-queries) u1))
            (ok query-id)
        )
    )
)

;; Claim Rewards
(define-public (claim-rewards (node-id uint))
    (let
        (
            (node-info (unwrap! (map-get? IndexNodes { node-id: node-id }) ERR_NODE_NOT_FOUND))
            (reward-info (unwrap! (map-get? NodeRewards { node-id: node-id }) ERR_NODE_NOT_FOUND))
            (pending (get pending-rewards reward-info))
        )
        (begin
            (asserts! (> pending u0) ERR_INSUFFICIENT_BALANCE)
            
            ;; Update rewards
            (map-set NodeRewards
                { node-id: node-id }
                (merge reward-info { 
                    total-earned: (+ (get total-earned reward-info) pending),
                    pending-rewards: u0,
                    last-claim: block-height
                })
            )
            
            ;; Update node total
            (map-set IndexNodes
                { node-id: node-id }
                (merge node-info { 
                    total-rewards-earned: (+ (get total-rewards-earned node-info) pending)
                })
            )
            
            (ok pending)
        )
    )
)

;; Update Performance Score
(define-public (update-performance (node-id uint) (new-score uint))
    (let
        (
            (node-info (unwrap! (map-get? IndexNodes { node-id: node-id }) ERR_NODE_NOT_FOUND))
        )
        (begin
            (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
            (asserts! (<= new-score u100) ERR_INVALID_DATA)
            
            (map-set IndexNodes
                { node-id: node-id }
                (merge node-info { performance-score: new-score })
            )
            (ok true)
        )
    )
)

;; Deactivate Node
(define-public (deactivate-node (node-id uint))
    (let
        (
            (node-info (unwrap! (map-get? IndexNodes { node-id: node-id }) ERR_NODE_NOT_FOUND))
        )
        (begin
            (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
            
            (map-set IndexNodes
                { node-id: node-id }
                (merge node-info { is-active: false })
            )
            (ok true)
        )
    )
)

;; Read-Only Functions
(define-read-only (get-node-info (node-id uint))
    (map-get? IndexNodes { node-id: node-id })
)

(define-read-only (get-shard-info (shard-id uint))
    (map-get? Shards { shard-id: shard-id })
)

(define-read-only (get-query-record (query-id uint))
    (map-get? QueryRecords { query-id: query-id })
)

(define-read-only (get-node-rewards (node-id uint))
    (map-get? NodeRewards { node-id: node-id })
)

(define-read-only (get-protocol-stats)
    {
        total-nodes: (var-get total-nodes),
        total-queries: (var-get total-queries),
        protocol-enabled: (var-get protocol-enabled)
    }
)

(define-read-only (calculate-query-fee (complexity uint))
    (+ BASE_QUERY_FEE (* complexity u2))
)
