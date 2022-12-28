local ffi = require('ffi')
local rocksdb = ffi.load('rocksdb')
local include_rocksdb = require('resty.rocksdb.include_cdef')
local ctype = require('resty.rocksdb.ctype')

local _M = {}


function _M.rocksdb_options_create()
    return rocksdb.rocksdb_options_create()
end


function _M.rocksdb_options_destroy(opts)
    return rocksdb.rocksdb_options_destroy(opts)
end


function _M.rocksdb_options_increase_parallelism(opts, cpu_num)
    return rocksdb.rocksdb_options_increase_parallelism(opts, ffi.new(ctype.int_t, cpu_num))
end


function _M.rocksdb_options_optimize_level_style_compaction(opts, memtable_memory_budget)
    return rocksdb.rocksdb_options_optimize_level_style_compaction(opts,
            ffi.new(ctype.uint64_t, memtable_memory_budget))
end


function _M.rocksdb_options_set_create_if_missing(opts, bool)
    return rocksdb.rocksdb_options_set_create_if_missing(opts, bool)
end

function _M.rocksdb_options_get_create_if_missing(opts)
    return rocksdb.rocksdb_options_get_create_if_missing(opts)
end

function _M.rocksdb_options_optimize_for_point_lookup(opts, block_cache_size_mb)
    return rocksdb.rocksdb_options_optimize_for_point_lookup(opts, ffi.new(ctype.uint64_t, block_cache_size_mb))
end


function _M.rocksdb_options_optimize_universal_style_compaction(opts, memtable_memory_budget)
    return rocksdb.rocksdb_options_optimize_universal_style_compaction(opts,
            ffi.new(ctype.uint64_t, memtable_memory_budget))
end


function _M.rocksdb_options_set_allow_ingest_behind(opts, bool)
    return rocksdb.rocksdb_options_set_allow_ingest_behind(opts, bool)
end


function _M.rocksdb_options_set_compaction_filter(opts, rocksdb_compactionfilter_t)
    return rocksdb.rocksdb_options_set_compaction_filter(opts, rocksdb_compactionfilter_t)
end


function _M.rocksdb_options_set_compaction_filter_factory(opts, rocksdb_compactionfilterfactory_t)
    return rocksdb.rocksdb_options_set_compaction_filter_factory(opts, rocksdb_compactionfilterfactory_t)
end


function _M.rocksdb_options_compaction_readahead_size(opts, size)
    return rocksdb.rocksdb_options_compaction_readahead_size(opts, ffi.new(ctype.size_t, size))
end


function _M.rocksdb_options_set_comparator(opts, rocksdb_comparator_t)
    return rocksdb.rocksdb_options_set_comparator(opts, rocksdb_comparator_t)
end


function _M.rocksdb_options_set_merge_operator(opts, rocksdb_mergeoperator_t)
    return rocksdb.rocksdb_options_set_merge_operator(opts, rocksdb_mergeoperator_t)
end


function _M.rocksdb_options_set_uint64add_merge_operator(opts)
    return rocksdb.rocksdb_options_set_uint64add_merge_operator(opts)
end


function _M.rocksdb_options_set_compression_per_level(opts, level_values, num_levels)
    return rocksdb.rocksdb_options_set_compression_per_level(opts,
            ffi.new(ctype.int_p_t, level_values), ffi.new(ctype.size_t, num_levels))
end


function _M.rocksdb_options_set_create_missing_column_families(opts, bool)
    return rocksdb.rocksdb_options_set_create_missing_column_families(opts, bool)
end


function _M.rocksdb_options_set_error_if_exists(opts, bool)
    return rocksdb.rocksdb_options_set_error_if_exists(opts, bool)
end


function _M.rocksdb_options_set_paranoid_checks(opts, bool)
    return rocksdb.rocksdb_options_set_paranoid_checks(opts, bool)
end


function _M.rocksdb_options_set_db_paths(opts, path_values, num_paths)
    return rocksdb.rocksdb_options_set_db_paths(opts, path_values, ffi.new(ctype.size_t, num_paths))
end


function _M.rocksdb_options_set_env(opts, rocksdb_env_t)
    return rocksdb.rocksdb_options_set_env(opts, rocksdb_env_t)
end


function _M.rocksdb_options_set_info_log(opts, rocksdb_logger_t)
    return rocksdb.rocksdb_options_set_info_log(opts, rocksdb_logger_t)
end


function _M.rocksdb_options_set_info_log_level(opts, level)
    return rocksdb.rocksdb_options_set_info_log_level(opts, ffi.new(ctype.int_t, level))
end


function _M.rocksdb_options_set_write_buffer_size(opts, size)
    return rocksdb.rocksdb_options_set_write_buffer_size(opts, ffi.new(ctype.size_t, size))
end


function _M.rocksdb_options_set_db_write_buffer_size(opts, size)
    return rocksdb.rocksdb_options_set_db_write_buffer_size(opts, ffi.new(ctype.size_t, size))
end


function _M.rocksdb_options_set_max_open_files(opts, max)
    return rocksdb.rocksdb_options_set_max_open_files(opts, ffi.new(ctype.int_t, max))
end


function _M.rocksdb_options_set_max_file_opening_threads(opts, num)
    return rocksdb.rocksdb_options_set_max_file_opening_threads(opts, ffi.new(ctype.int_t, num))
end


function _M.rocksdb_options_set_max_total_wal_size(opts, num)
    return rocksdb.rocksdb_options_set_max_total_wal_size(opts, ffi.new(ctype.uint64_t, num))
end


function _M.rocksdb_options_set_compression_options(opts, num1, num2, num3, num4)
    return rocksdb.rocksdb_options_set_compression_options(opts, ffi.new(ctype.int_t, num1),
           ffi.new(ctype.int_t, num2), ffi.new(ctype.int_t, num3), ffi.new(ctype.int_t, num4))
end


function _M.rocksdb_options_set_prefix_extractor(opts, rocksdb_slicetransform_t)
    return rocksdb.rocksdb_options_set_prefix_extractor(opts, rocksdb_slicetransform_t)
end


function _M.rocksdb_options_set_num_levels(opts, num)
    return rocksdb.rocksdb_options_set_num_levels(opts, ffi.new(ctype.int_t, num))
end


function _M.rocksdb_options_set_level0_file_num_compaction_trigger(opts, num)
    return rocksdb.rocksdb_options_set_level0_file_num_compaction_trigger(opts, ffi.new(ctype.int_t, num))
end


function _M.rocksdb_options_set_level0_slowdown_writes_trigger(opts, num)
    return rocksdb.rocksdb_options_set_level0_slowdown_writes_trigger(opts, ffi.new(ctype.int_t, num))
end


function _M.rocksdb_options_set_level0_stop_writes_trigger(opts, num)
    return rocksdb.rocksdb_options_set_level0_stop_writes_trigger(opts, ffi.new(ctype.int_t, num))
end


function _M.rocksdb_options_set_max_mem_compaction_level(opts, num)
    return rocksdb.rocksdb_options_set_max_mem_compaction_level(opts, ffi.new(ctype.int_t, num))
end


function _M.rocksdb_options_set_target_file_size_base(opts, num)
    return rocksdb.rocksdb_options_set_target_file_size_base(opts, ffi.new(ctype.uint64_t, num))
end


function _M.rocksdb_options_set_target_file_size_multiplier(opts, num)
    return rocksdb.rocksdb_options_set_target_file_size_multiplier(opts, ffi.new(ctype.int_t, num))
end


function _M.rocksdb_options_set_max_bytes_for_level_base(opts, num)
    return rocksdb.rocksdb_options_set_max_bytes_for_level_base(opts, ffi.new(ctype.uint64_t, num))
end


function _M.rocksdb_options_set_level_compaction_dynamic_level_bytes(opts, bool)
    return rocksdb.rocksdb_options_set_level_compaction_dynamic_level_bytes(opts, bool)
end


function _M.rocksdb_options_set_max_bytes_for_level_multiplier(opts, level)
    return rocksdb.rocksdb_options_set_max_bytes_for_level_multiplier(opts, level)
end


function _M.rocksdb_options_set_max_bytes_for_level_multiplier_additional(opts, level_values, num_levels)
    return rocksdb.rocksdb_options_set_max_bytes_for_level_multiplier_additional(opts,
            ffi.new(ctype.int_p_t, level_values), ffi.new(ctype.size_t, num_levels))
end


function _M.rocksdb_options_enable_statistics(opts)
    return rocksdb.rocksdb_options_enable_statistics(opts)
end


function _M.rocksdb_options_set_skip_stats_update_on_db_open(opts, bool)
    return rocksdb.rocksdb_options_set_skip_stats_update_on_db_open(opts, bool)
end


function _M.rocksdb_options_set_skip_checking_sst_file_sizes_on_db_open(opts, bool)
    return rocksdb.rocksdb_options_set_skip_checking_sst_file_sizes_on_db_open(opts, bool)
end


function _M.rocksdb_options_statistics_get_string(opts)
    return rocksdb.rocksdb_options_statistics_get_string(opts)
end


function _M.rocksdb_options_set_max_write_buffer_number(opts, num)
    return rocksdb.rocksdb_options_set_max_write_buffer_number(opts, ffi.new(ctype.int_t, num))
end


function _M.rocksdb_options_set_min_write_buffer_number_to_merge(opts, num)
    return rocksdb.rocksdb_options_set_min_write_buffer_number_to_merge(opts, ffi.new(ctype.int_t, num))
end


function _M.rocksdb_options_set_max_write_buffer_number_to_maintain(opts, num)
    return rocksdb.rocksdb_options_set_max_write_buffer_number_to_maintain(opts, ffi.new(ctype.int_t, num))
end


function _M.rocksdb_options_set_max_write_buffer_size_to_maintain(opts, num)
    return rocksdb.rocksdb_options_set_max_write_buffer_size_to_maintain(opts, ffi.new(ctype.uint64_t, num))
end


function _M.rocksdb_options_set_enable_pipelined_write(opts, bool)
    return rocksdb.rocksdb_options_set_enable_pipelined_write(opts, bool)
end


function _M.rocksdb_options_set_unordered_write(opts, bool)
    return rocksdb.rocksdb_options_set_unordered_write(opts, bool)
end


function _M.rocksdb_options_set_max_subcompactions(opts, num)
    return rocksdb.rocksdb_options_set_max_subcompactions(opts, ffi.new(ctype.uint32_t, num))
end


function _M.rocksdb_options_set_max_background_jobs(opts, num)
    return rocksdb.rocksdb_options_set_max_background_jobs(opts, ffi.new(ctype.int_t, num))
end


function _M.rocksdb_options_set_max_background_compactions(opts, num)
    return rocksdb.rocksdb_options_set_max_background_compactions(opts, ffi.new(ctype.int_t, num))
end


function _M.rocksdb_options_set_base_background_compactions(opts, num)
    return rocksdb.rocksdb_options_set_base_background_compactions(opts, ffi.new(ctype.int_t, num))
end


function _M.rocksdb_options_set_max_background_flushes(opts, num)
    return rocksdb.rocksdb_options_set_max_background_flushes(opts, ffi.new(ctype.int_t, num))
end


function _M.rocksdb_options_set_max_log_file_size(opts, size)
    return rocksdb.rocksdb_options_set_max_log_file_size(opts, ffi.new(ctype.size_t, size))
end


function _M.rocksdb_options_set_log_file_time_to_roll(opts, size)
    return rocksdb.rocksdb_options_set_log_file_time_to_roll(opts, ffi.new(ctype.size_t, size))
end


function _M.rocksdb_options_set_keep_log_file_num(opts, size)
    return rocksdb.rocksdb_options_set_keep_log_file_num(opts, ffi.new(ctype.size_t, size))
end


function _M.rocksdb_options_set_recycle_log_file_num(opts, size)
    return rocksdb.rocksdb_options_set_recycle_log_file_num(opts, ffi.new(ctype.size_t, size))
end


function _M.rocksdb_options_set_soft_rate_limit(opts, limit)
    return rocksdb.rocksdb_options_set_soft_rate_limit(opts, limit)
end


function _M.rocksdb_options_set_hard_rate_limit(opts, limit)
    return rocksdb.rocksdb_options_set_hard_rate_limit(opts, limit)
end


function _M.rocksdb_options_set_soft_pending_compaction_bytes_limit(opts, v)
    return rocksdb.rocksdb_options_set_soft_pending_compaction_bytes_limit(opts, ffi.new(ctype.size_t, v))
end


function _M.rocksdb_options_set_hard_pending_compaction_bytes_limit(opts, v)
    return rocksdb.rocksdb_options_set_hard_pending_compaction_bytes_limit(opts, ffi.new(ctype.size_t, v))
end


function _M.rocksdb_options_set_rate_limit_delay_max_milliseconds(opts, num)
    return rocksdb.rocksdb_options_set_rate_limit_delay_max_milliseconds(opts, ffi.new(ctype.uint64_t, num))
end


function _M.rocksdb_options_set_max_manifest_file_size(opts, size)
    return rocksdb.rocksdb_options_set_max_manifest_file_size(opts, ffi.new(ctype.size_t, size))
end


function _M.rocksdb_options_set_table_cache_numshardbits(opts, num)
    return rocksdb.rocksdb_options_set_table_cache_numshardbits(opts, ffi.new(ctype.int_t, num))
end


function _M.rocksdb_options_set_table_cache_remove_scan_count_limit(opts, num)
    return rocksdb.rocksdb_options_set_table_cache_remove_scan_count_limit(opts, ffi.new(ctype.int_t, num))
end


function _M.rocksdb_options_set_arena_block_size(opts, size)
    return rocksdb.rocksdb_options_set_arena_block_size(opts, ffi.new(ctype.size_t, size))
end


function _M.rocksdb_block_based_options_set_no_block_cache(opts, bool)
    return rocksdb.rocksdb_block_based_options_set_no_block_cache(opts, bool)
end


function _M.rocksdb_block_based_options_set_block_cache(opts, size)
    return rocksdb.rocksdb_block_based_options_set_block_cache(opts, ffi.new(ctype.size_t, size))
end


function _M.rocksdb_options_set_use_fsync(opts, size)
    return rocksdb.rocksdb_options_set_use_fsync(opts, ffi.new(ctype.size_t, size))
end


function _M.rocksdb_options_set_db_log_dir(opts, dir)
    return rocksdb.rocksdb_options_set_db_log_dir(opts, dir)
end


function _M.rocksdb_options_set_wal_dir(opts, dir)
    return rocksdb.rocksdb_options_set_wal_dir(opts, dir)
end


function _M.rocksdb_options_set_WAL_ttl_seconds(opts, sec)
    return rocksdb.rocksdb_options_set_WAL_ttl_seconds(opts, ffi.new(ctype.uint64_t, sec))
end


function _M.rocksdb_options_set_WAL_size_limit_MB(opts, limit)
    return rocksdb.rocksdb_options_set_WAL_size_limit_MB(opts, ffi.new(ctype.uint64_t, limit))
end


function _M.rocksdb_options_set_manifest_preallocation_size(opts, size)
    return rocksdb.rocksdb_options_set_manifest_preallocation_size(opts, ffi.new(ctype.size_t, size))
end


function _M.rocksdb_options_set_purge_redundant_kvs_while_flush(opts, bool)
    return rocksdb.rocksdb_options_set_purge_redundant_kvs_while_flush(opts, bool)
end


function _M.rocksdb_options_set_allow_mmap_reads(opts, bool)
    return rocksdb.rocksdb_options_set_allow_mmap_reads(opts, bool)
end


function _M.rocksdb_options_set_allow_mmap_writes(opts, bool)
    return rocksdb.rocksdb_options_set_allow_mmap_writes(opts, bool)
end


function _M.rocksdb_options_set_use_direct_reads(opts, bool)
    return rocksdb.rocksdb_options_set_use_direct_reads(opts, bool)
end


function _M.rocksdb_options_set_use_direct_io_for_flush_and_compaction(opts, bool)
    return rocksdb.rocksdb_options_set_use_direct_io_for_flush_and_compaction(opts, bool)
end


function _M.rocksdb_options_set_is_fd_close_on_exec(opts, bool)
    return rocksdb.rocksdb_options_set_is_fd_close_on_exec(opts, bool)
end


function _M.rocksdb_options_set_skip_log_error_on_recovery(opts, bool)
    return rocksdb.rocksdb_options_set_skip_log_error_on_recovery(opts, bool)
end


function _M.rocksdb_options_set_stats_dump_period_sec(opts, num)
    return rocksdb.rocksdb_options_set_stats_dump_period_sec(opts, ffi.new(ctype.int_t, num))
end


function _M.rocksdb_options_set_advise_random_on_open(opts, bool)
    return rocksdb.rocksdb_options_set_advise_random_on_open(opts, bool)
end


function _M.rocksdb_options_set_access_hint_on_compaction_start(opts, num)
    return rocksdb.rocksdb_options_set_access_hint_on_compaction_start(opts, ffi.new(ctype.int_t, num))
end


function _M.rocksdb_options_set_use_adaptive_mutex(opts, bool)
    return rocksdb.rocksdb_options_set_use_adaptive_mutex(opts, bool)
end


function _M.rocksdb_options_set_bytes_per_sync(opts, bytes)
    return rocksdb.rocksdb_options_set_bytes_per_sync(opts, ffi.new(ctype.uint64_t, bytes))
end


function _M.rocksdb_options_set_wal_bytes_per_sync(opts, bytes)
    return rocksdb.rocksdb_options_set_wal_bytes_per_sync(opts, ffi.new(ctype.uint64_t, bytes))
end


function _M.rocksdb_options_set_writable_file_max_buffer_size(opts, size)
    return rocksdb.rocksdb_options_set_writable_file_max_buffer_size(opts, ffi.new(ctype.uint64_t, size))
end


function _M.rocksdb_options_set_allow_concurrent_memtable_write(opts, bool)
    return rocksdb.rocksdb_options_set_allow_concurrent_memtable_write(opts, bool)
end


function _M.rocksdb_options_set_enable_write_thread_adaptive_yield(opts, bool)
    return rocksdb.rocksdb_options_set_enable_write_thread_adaptive_yield(opts, bool)
end


function _M.rocksdb_options_set_max_sequential_skip_in_iterations(opts, max)
    return rocksdb.rocksdb_options_set_max_sequential_skip_in_iterations(opts, ffi.new(ctype.uint64_t, max))
end


function _M.rocksdb_options_set_disable_auto_compactions(opts, num)
    return rocksdb.rocksdb_options_set_disable_auto_compactions(opts, ffi.new(ctype.int_t, num))
end


function _M.rocksdb_options_set_optimize_filters_for_hits(opts, num)
    return rocksdb.rocksdb_options_set_optimize_filters_for_hits(opts, ffi.new(ctype.int_t, num))
end


function _M.rocksdb_options_set_delete_obsolete_files_period_micros(opts, period)
    return rocksdb.rocksdb_options_set_delete_obsolete_files_period_micros(opts, ffi.new(ctype.uint64_t, period))
end


function _M.rocksdb_options_prepare_for_bulk_load(opts)
    return rocksdb.rocksdb_options_prepare_for_bulk_load(opts)
end


function _M.rocksdb_options_set_memtable_vector_rep(opts)
    return rocksdb.rocksdb_options_set_memtable_vector_rep(opts)
end


function _M.rocksdb_options_set_memtable_prefix_bloom_size_ratio(opts, size)
    return rocksdb.rocksdb_options_set_memtable_prefix_bloom_size_ratio(opts, size)
end


function _M.rocksdb_options_set_max_compaction_bytes(opts, max)
    return rocksdb.rocksdb_options_set_max_compaction_bytes(opts, ffi.new(ctype.uint64_t, max))
end


function _M.rocksdb_options_set_hash_skip_list_rep(opts, bucket_count, skiplist_height, skiplist_branching_factor)
    return rocksdb.rocksdb_options_set_hash_skip_list_rep(opts, ffi.new(ctype.size_t, bucket_count),
            ffi.new(ctype.uint32_t, skiplist_height), ffi.new(ctype.uint32_t, skiplist_branching_factor))
end


function _M.rocksdb_options_set_hash_link_list_rep(opts, size)
    return rocksdb.rocksdb_options_set_hash_link_list_rep(opts, ffi.new(ctype.size_t, size))
end


function _M.rocksdb_options_set_plain_table_factory(opts, user_key_len, bloom_bits_per_key, index_sparseness)
    return rocksdb.rocksdb_options_set_plain_table_factory(opts, ffi.new(ctype.size_t, user_key_len),
           ffi.new(ctype.uint32_t, bloom_bits_per_key), ffi.new(ctype.uint32_t, index_sparseness))
end


function _M.rocksdb_options_set_min_level_to_compress(opts, level)
    return rocksdb.rocksdb_options_set_min_level_to_compress(opts, ffi.new(ctype.int_t, level))
end


function _M.rocksdb_options_set_memtable_huge_page_size(opts, size)
    return rocksdb.rocksdb_options_set_memtable_huge_page_size(opts, ffi.new(ctype.size_t, size))
end


function _M.rocksdb_options_set_max_successive_merges(opts, max)
    return rocksdb.rocksdb_options_set_max_successive_merges(opts, ffi.new(ctype.size_t, max))
end


function _M.rocksdb_options_set_bloom_locality(opts, v)
    return rocksdb.rocksdb_options_set_bloom_locality(opts, ffi.new(ctype.uint32_t, v))
end


function _M.rocksdb_options_set_inplace_update_support(opts, bool)
    return rocksdb.rocksdb_options_set_inplace_update_support(opts, bool)
end


function _M.rocksdb_options_set_inplace_update_num_locks(opts, num)
    return rocksdb.rocksdb_options_set_inplace_update_num_locks(opts, ffi.new(ctype.size_t, num))
end


function _M.rocksdb_options_set_report_bg_io_stats(opts, v)
    return rocksdb.rocksdb_options_set_report_bg_io_stats(opts, ffi.new(ctype.int_t, v))
end


function _M.rocksdb_options_set_compression(opts, v)
    return rocksdb.rocksdb_options_set_compression(opts, ffi.new(ctype.int_t, v))
end


function _M.rocksdb_options_set_compaction_style(opts, v)
    return rocksdb.rocksdb_options_set_compaction_style(opts, ffi.new(ctype.int_t, v))
end


function _M.rocksdb_options_set_universal_compaction_options(opts, rocksdb_universal_compaction_options_t)
    return rocksdb.rocksdb_options_set_universal_compaction_options(opts, rocksdb_universal_compaction_options_t)
end


function _M.rocksdb_options_set_fifo_compaction_options(opts, rocksdb_fifo_compaction_options_t)
    return rocksdb.rocksdb_options_set_fifo_compaction_options(opts, rocksdb_fifo_compaction_options_t)
end


function _M.rocksdb_options_set_ratelimiter(opts, rocksdb_ratelimiter_t)
    return rocksdb.rocksdb_options_set_ratelimiter(opts, rocksdb_ratelimiter_t)
end


function _M.rocksdb_options_set_atomic_flush(opts, bool)
    return rocksdb.rocksdb_options_set_atomic_flush(opts, bool)
end


function _M.rocksdb_options_set_row_cache(opts, rocksdb_cache_t)
    return rocksdb.rocksdb_options_set_row_cache(opts, rocksdb_cache_t)
end


function _M.rocksdb_block_based_options_create()
    return rocksdb.rocksdb_block_based_options_create()
end


function _M.rocksdb_block_based_options_destroy(rocksdb_block_based_table_options_t)
    return rocksdb.rocksdb_block_based_options_destroy(rocksdb_block_based_table_options_t)
end


function _M.rocksdb_block_based_options_set_no_block_cache(opts, bool)
    return rocksdb.rocksdb_block_based_options_set_no_block_cache(opts, bool)
end


function _M.rocksdb_options_set_db_write_buffer_size(opts, size)
    return rocksdb.rocksdb_options_set_db_write_buffer_size(opts, ffi.new(ctype.size_t, size))
end


function _M.rocksdb_block_based_options_set_block_cache(opts, block_cache)
    return rocksdb.rocksdb_block_based_options_set_block_cache(opts, block_cache)
end


function _M.rocksdb_block_based_options_set_cache_index_and_filter_blocks_with_high_priority(opts, bool)
    return rocksdb.rocksdb_block_based_options_set_cache_index_and_filter_blocks_with_high_priority(opts, bool)
end


function _M.rocksdb_block_based_options_set_block_size(opts, size)
    return rocksdb.rocksdb_block_based_options_set_block_size(opts, ffi.new(ctype.size_t, size))
end


function _M.rocksdb_block_based_options_set_cache_index_and_filter_blocks(opt, bool)
    return rocksdb.rocksdb_block_based_options_set_cache_index_and_filter_blocks(opt, bool)
end


function _M.rocksdb_options_set_block_based_table_factory(opts, table_options)
    return rocksdb.rocksdb_options_set_block_based_table_factory(opts, table_options)
end


function _M.rocksdb_get_options_from_string(base_opt, opt_str, new_opt)
    local err = ffi.new(ctype.str_array_t, 1)
    rocksdb.rocksdb_get_options_from_string(base_opt, opt_str, new_opt, err)
    if err[0] ~= nil then
        return nil, 'GetOptionErr', ffi.string(err[0])
    end
    return nil
end


function _M.rocksdb_writeoptions_create()
    return rocksdb.rocksdb_writeoptions_create()
end


function _M.rocksdb_writeoptions_destroy(write_opts)
    return rocksdb.rocksdb_writeoptions_destroy(write_opts)
end


function _M.rocksdb_writeoptions_set_sync(write_opts, bool)
    return rocksdb.rocksdb_writeoptions_set_sync(write_opts, bool)
end


function _M.rocksdb_writeoptions_disable_WAL(write_opts, disable)
    return rocksdb.rocksdb_writeoptions_disable_WAL(write_opts, ffi.new(ctype.int_t, disable))
end


function _M.rocksdb_writeoptions_set_ignore_missing_column_families(write_opts, bool)
    return rocksdb.rocksdb_writeoptions_set_ignore_missing_column_families(write_opts, bool)
end


function _M.rocksdb_writeoptions_set_no_slowdown(write_opts, bool)
    return rocksdb.rocksdb_writeoptions_set_no_slowdown(write_opts, bool)
end


function _M.rocksdb_writeoptions_set_low_pri(write_opts, bool)
    return rocksdb.rocksdb_writeoptions_set_low_pri(write_opts, bool)
end


function _M.rocksdb_readoptions_create()
    return rocksdb.rocksdb_readoptions_create()
end


function _M.rocksdb_readoptions_destroy(read_opts)
    return rocksdb.rocksdb_readoptions_destroy(read_opts)
end


function _M.rocksdb_readoptions_set_total_order_seek(read_opts, bool)
     return rocksdb.rocksdb_readoptions_set_total_order_seek(read_opts, bool)
end


function _M.rocksdb_readoptions_set_iterate_upper_bound(read_opts, key)
     return rocksdb.rocksdb_readoptions_set_iterate_upper_bound(read_opts, key, #key)
end


function _M.rocksdb_readoptions_set_iterate_lower_bound(read_opts, key)
     return rocksdb.rocksdb_readoptions_set_iterate_lower_bound(read_opts, key, #key)
end


function _M.rocksdb_readoptions_destroy(read_opts)
    return rocksdb.rocksdb_readoptions_destroy(read_opts)
end


function _M.rocksdb_readoptions_set_fill_cache(read_opts, bool)
    return rocksdb.rocksdb_readoptions_set_fill_cache(read_opts, bool)
end


function _M.rocksdb_cache_create_lru(capacity)
    return rocksdb.rocksdb_cache_create_lru(capacity)
end


function _M.rocksdb_cache_destroy(rocksdb_cache_t)
    return rocksdb.rocksdb_cache_destroy(rocksdb_cache_t)
end


local OPT_FUN_LIST = {
    ['increase_parallelism'] = _M.rocksdb_options_increase_parallelism,
    ['optimize_level_style_compaction'] = _M.rocksdb_options_optimize_level_style_compaction,
    ['create_if_missing'] = _M.rocksdb_options_set_create_if_missing,
    ['target_file_size_base'] = _M.rocksdb_options_set_target_file_size_base,
    ['optimize_for_point_lookup'] = _M.rocksdb_options_optimize_for_point_lookup,
    ['optimize_universal_style_compaction'] = _M.rocksdb_options_optimize_universal_style_compaction,
    ['allow_ingest_behind'] = _M.rocksdb_options_set_allow_ingest_behind,
    ['optimize_universal_style_compaction'] = _M.rocksdb_options_optimize_universal_style_compaction,
    ['compaction_filter'] = _M.rocksdb_options_set_compaction_filter,
    ['compaction_filter_factory'] = _M.rocksdb_options_set_compaction_filter_factory,
    ['compaction_readahead_size'] = _M.rocksdb_options_compaction_readahead_size,
    ['comparator'] = _M.rocksdb_options_set_comparator,
    ['merge_operator'] = _M.rocksdb_options_set_merge_operator,
    ['uint64add_merge_operator'] = _M.rocksdb_options_set_uint64add_merge_operator,
    ['compression_per_level'] = _M.rocksdb_options_set_compression_per_level,
    ['create_missing_column_families'] = _M.rocksdb_options_set_create_missing_column_families,
    ['error_if_exists'] = _M.rocksdb_options_set_error_if_exists,
    ['paranoid_checks'] = _M.rocksdb_options_set_paranoid_checks,
    ['db_paths'] = _M.rocksdb_options_set_db_paths,
    ['env'] = _M.rocksdb_options_set_env,
    ['info_log'] = _M.rocksdb_options_set_info_log,
    ['info_log_level'] = _M.rocksdb_options_set_info_log_level,
    ['set_write_buffer_size'] = _M.rocksdb_options_set_write_buffer_size,
    ['db_write_buffer_size'] = _M.rocksdb_options_set_db_write_buffer_size,
    ['max_open_files'] = _M.rocksdb_options_set_max_open_files,
    ['max_file_opening_threads'] = _M.rocksdb_options_set_max_file_opening_threads,
    ['max_total_wal_size'] = _M.rocksdb_options_set_max_total_wal_size,
    ['compression_options'] = _M.rocksdb_options_set_compression_options,
    ['prefix_extractor'] = _M.rocksdb_options_set_prefix_extractor,
    ['num_levels'] = _M.rocksdb_options_set_num_levels,
    ['level0_file_num_compaction_trigger'] = _M.rocksdb_options_set_level0_file_num_compaction_trigger,
    ['level0_slowdown_writes_trigger'] = _M.rocksdb_options_set_level0_slowdown_writes_trigger,
    ['level0_stop_writes_trigger'] = _M.rocksdb_options_set_level0_stop_writes_trigger,
    ['max_mem_compaction_level'] = _M.rocksdb_options_set_max_mem_compaction_level,
    ['max_bytes_for_level_base'] = _M.rocksdb_options_set_max_bytes_for_level_base,
    ['level_compaction_dynamic_level_bytes'] = _M.rocksdb_options_set_level_compaction_dynamic_level_bytes,
    ['max_bytes_for_level_multiplier'] = _M.rocksdb_options_set_max_bytes_for_level_multiplier,
    ['max_bytes_for_level_multiplier_additional'] = _M.rocksdb_options_set_max_bytes_for_level_multiplier_additional,
    ['enable_statistics'] = _M.rocksdb_options_enable_statistics,
    ['skip_stats_update_on_db_open'] = _M.rocksdb_options_set_skip_stats_update_on_db_open,
    ['skip_checking_sst_file_sizes_on_db_open'] = _M.rocksdb_options_set_skip_checking_sst_file_sizes_on_db_open,
    ['statistics_get_string'] = _M.rocksdb_options_statistics_get_string,
    ['max_write_buffer_number'] = _M.rocksdb_options_set_max_write_buffer_number,
    ['min_write_buffer_number_to_merge'] = _M.rocksdb_options_set_min_write_buffer_number_to_merge,
    ['max_write_buffer_number_to_maintain'] = _M.rocksdb_options_set_max_write_buffer_number_to_maintain,
    ['max_write_buffer_size_to_maintain'] = _M.rocksdb_options_set_max_write_buffer_size_to_maintain,
    ['enable_pipelined_write'] = _M.rocksdb_options_set_enable_pipelined_write,
    ['unordered_write'] = _M.rocksdb_options_set_unordered_write,
    ['max_subcompactions'] = _M.rocksdb_options_set_max_subcompactions,
    ['max_background_jobs'] = _M.rocksdb_options_set_max_background_jobs,
    ['max_background_compactions'] = _M.rocksdb_options_set_max_background_compactions,
    ['base_background_compactions'] = _M.rocksdb_options_set_base_background_compactions,
    ['max_background_flushes'] = _M.rocksdb_options_set_max_background_flushes,
    ['max_log_file_size'] = _M.rocksdb_options_set_max_log_file_size,
    ['log_file_time_to_roll'] = _M.rocksdb_options_set_log_file_time_to_roll,
    ['keep_log_file_num'] = _M.rocksdb_options_set_keep_log_file_num,
    ['recycle_log_file_num'] = _M.rocksdb_options_set_recycle_log_file_num,
    ['soft_rate_limit'] = _M.rocksdb_options_set_soft_rate_limit,
    ['hard_rate_limit'] = _M.rocksdb_options_set_hard_rate_limit,
    ['soft_pending_compaction_bytes_limit'] = _M.rocksdb_options_set_soft_pending_compaction_bytes_limit,
    ['hard_pending_compaction_bytes_limit'] = _M.rocksdb_options_set_soft_pending_compaction_bytes_limit,
    ['rate_limit_delay_max_milliseconds'] = _M.rocksdb_options_set_rate_limit_delay_max_milliseconds,
    ['max_manifest_file_size'] = _M.rocksdb_options_set_max_manifest_file_size,
    ['table_cache_numshardbits'] = _M.rocksdb_options_set_table_cache_numshardbits,
    ['table_cache_remove_scan_count_limit'] = _M.rocksdb_options_set_table_cache_remove_scan_count_limit,
    ['arena_block_size'] = _M.rocksdb_options_set_arena_block_size,
    ['use_fsync'] = _M.rocksdb_options_set_use_fsync,
    ['db_log_dir'] = _M.rocksdb_options_set_db_log_dir,
    ['wal_dir'] = _M.rocksdb_options_set_db_log_dir,
    ['WAL_ttl_seconds'] = _M.rocksdb_options_set_WAL_ttl_seconds,
    ['WAL_size_limit_MB'] = _M.rocksdb_options_set_WAL_size_limit_MB,
    ['manifest_preallocation_size'] = _M.rocksdb_options_set_manifest_preallocation_size,
    ['purge_redundant_kvs_while_flush'] = _M.rocksdb_options_set_purge_redundant_kvs_while_flush,
    ['allow_mmap_reads'] = _M.rocksdb_options_set_allow_mmap_reads,
    ['allow_mmap_writes'] = _M.rocksdb_options_set_allow_mmap_writes,
    ['use_direct_reads'] = _M.rocksdb_options_set_use_direct_reads,
    ['use_direct_io_for_flush_and_compaction'] = _M.rocksdb_options_set_use_direct_io_for_flush_and_compaction,
    ['is_fd_close_on_exec'] = _M.rocksdb_options_set_is_fd_close_on_exec,
    ['skip_log_error_on_recovery'] = _M.rocksdb_options_set_skip_log_error_on_recovery,
    ['stats_dump_period_sec'] = _M.rocksdb_options_set_stats_dump_period_sec,
    ['advise_random_on_open'] = _M.rocksdb_options_set_advise_random_on_open,
    ['access_hint_on_compaction_start'] = _M.rocksdb_options_set_access_hint_on_compaction_start,
    ['use_adaptive_mutex'] = _M.rocksdb_options_set_use_adaptive_mutex,
    ['bytes_per_sync'] = _M.rocksdb_options_set_bytes_per_sync,
    ['wal_bytes_per_sync'] = _M.rocksdb_options_set_wal_bytes_per_sync,
    ['writable_file_max_buffer_size'] = _M.rocksdb_options_set_writable_file_max_buffer_size,
    ['allow_concurrent_memtable_write'] = _M.rocksdb_options_set_allow_concurrent_memtable_write,
    ['enable_write_thread_adaptive_yield'] = _M.rocksdb_options_set_enable_write_thread_adaptive_yield,
    ['sequential_skip_in_iterations'] = _M.rocksdb_options_set_max_sequential_skip_in_iterations,
    ['disable_auto_compactions'] = _M.rocksdb_options_set_disable_auto_compactions,
    ['optimize_filters_for_hits'] = _M.rocksdb_options_set_optimize_filters_for_hits,
    ['delete_obsolete_files_period_micros'] = _M.rocksdb_options_set_delete_obsolete_files_period_micros,
    ['prepare_for_bulk_load'] = _M.rocksdb_options_prepare_for_bulk_load,
    ['memtable_vector_rep'] = _M.rocksdb_options_set_memtable_vector_rep,
    ['memtable_prefix_bloom_size_ratio'] = _M.rocksdb_options_set_memtable_prefix_bloom_size_ratio,
    ['max_compaction_bytes'] = _M.rocksdb_options_set_max_compaction_bytes,
    ['hash_skip_list_rep'] = _M.rocksdb_options_set_hash_skip_list_rep,
    ['hash_link_list_rep'] = _M.rocksdb_options_set_hash_link_list_rep,
    ['plain_table_factory'] = _M.rocksdb_options_set_plain_table_factory,
    ['min_level_to_compress'] = _M.rocksdb_options_set_min_level_to_compress,
    ['memtable_huge_page_size'] = _M.rocksdb_options_set_memtable_huge_page_size,
    ['max_successive_merges'] = _M.rocksdb_options_set_max_successive_merges,
    ['bloom_locality'] = _M.rocksdb_options_set_bloom_locality,
    ['inplace_update_support'] = _M.rocksdb_options_set_inplace_update_support,
    ['inplace_update_num_locks'] = _M.rocksdb_options_set_inplace_update_num_locks,
    ['report_bg_io_stats'] = _M.rocksdb_options_set_report_bg_io_stats,
    ['compression'] = _M.rocksdb_options_set_compression,
    ['compaction_style'] = _M.rocksdb_options_set_compaction_style,
    ['universal_compaction_options'] = _M.rocksdb_options_set_universal_compaction_options,
    ['fifo_compaction_options'] = _M.rocksdb_options_set_fifo_compaction_options,
    ['ratelimiter'] = _M.rocksdb_options_set_ratelimiter,
    ['atomic_flush'] = _M.rocksdb_options_set_atomic_flush,
    ['row_cache'] = _M.rocksdb_options_set_row_cache,
}

--local options_table = {
--    ["opt_fun_name1"] = {"args1", "args2"},
--    ["opt_fun_name2"] = {"args1", "args2"},
--    ["opt_fun_name3"] = {"args1", "args2"},
--}


function _M.set_option(opt, options_table)
    for opt_fun, args in pairs(options_table) do
        OPT_FUN_LIST[opt_fun](opt, unpack(args))
    end
end


return _M
