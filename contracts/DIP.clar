;; Decentralized Indexing Protocol - Initial Implementation
;; Version 1.0

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_INVALID_DATA (err u101))

;; Data Variables
(define-data-var protocol-enabled bool true)

;; Data Types
(define-map IndexNodes
    { node-id: uint }
    {
        data-type: (string-ascii 64),
        start-time: uint,
        end-time: uint,
        storage-location: (string-ascii 256),
        query-endpoint: (string-ascii 256),
        stake-amount: uint,
        is-active: bool
    }
)

(define-map TimeRanges
    { range-id: uint }
    {
        start: uint,
        end: uint,
        node-id: uint
    }
)

;; Storage Configuration
(define-map StorageConfigs
    { config-id: uint }
    {
        shard-size: uint,
        redundancy-factor: uint,
        compression-enabled: bool
    }
)

;; Principal Functions
(define-public (register-node 
    (node-id uint) 
    (data-type (string-ascii 64))
    (start-time uint)
    (end-time uint)
    (storage-location (string-ascii 256))
    (query-endpoint (string-ascii 256))
    (stake-amount uint))
    (begin
        (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
        (asserts! (> stake-amount u0) ERR_INVALID_DATA)
        (asserts! (< start-time end-time) ERR_INVALID_DATA)
        
        (map-set IndexNodes
            { node-id: node-id }
            {
                data-type: data-type,
                start-time: start-time,
                end-time: end-time,
                storage-location: storage-location,
                query-endpoint: query-endpoint,
                stake-amount: stake-amount,
                is-active: true
            }
        )
        (ok true)
    )
)

(define-public (configure-storage
    (config-id uint)
    (shard-size uint)
    (redundancy-factor uint)
    (compression-enabled bool))
    (begin
        (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
        (asserts! (> shard-size u0) ERR_INVALID_DATA)
        (asserts! (> redundancy-factor u0) ERR_INVALID_DATA)
        
        (map-set StorageConfigs
            { config-id: config-id }
            {
                shard-size: shard-size,
                redundancy-factor: redundancy-factor,
                compression-enabled: compression-enabled
            }
        )
        (ok true)
    )
)

;; Query Functions
(define-read-only (get-node-info (node-id uint))
    (map-get? IndexNodes { node-id: node-id })
)

(define-read-only (get-storage-config (config-id uint))
    (map-get? StorageConfigs { config-id: config-id })
)

;; Helper Functions
(define-private (validate-time-range (start uint) (end uint))
    (and (> end start) (> start u0))
)

(define-private (calculate-stake-requirement (data-type (string-ascii 64)) (time-range uint))
    ;; Basic stake calculation based on data type and time range
    (+ u1000 (* time-range u10))
)