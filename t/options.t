use Test::Nginx::Socket::Lua 'no_plan';
use Cwd qw(cwd);

my $pwd = cwd();

our $HttpConfig = qq{
    lua_package_path "$pwd/?.lua;$pwd/lib/resty/rocksdb/?.lua;;";
    lua_package_cpath "$pwd/?.so;$pwd/lib/resty/rocksdb/?.so;;";
};

no_long_string();
run_tests();

__DATA__

=== TEST 1: test create options by string
This test will open new options

--- http_config eval: $::HttpConfig
--- config
location = /t {
    rewrite_by_lua_block {
        local rocksdb = require("rocksdb")
        local options = require("options")
        local opts = options.rocksdb_options_create()
        local new_opts = options.rocksdb_options_create()

        local _, err_code, err_msg = options.rocksdb_get_options_from_string(
        opts,
        [[create_if_missing=true;
        prefix_extractor=rocksdb.CappedPrefix.13;
        max_bytes_for_level_base=986;
        bloom_locality=8016;
        target_file_size_base=4294976376;
        memtable_huge_page_size=2557;
        num_levels=99;
        level0_slowdown_writes_trigger=22;
        level0_file_num_compaction_trigger=14;
        soft_rate_limit=530.615385;
        soft_pending_compaction_bytes_limit=0;
        max_write_buffer_number_to_maintain=84;
        verify_checksums_in_compaction=false;
        memtable_prefix_bloom_size_ratio=0.4642;
        paranoid_file_checks=true;
        force_consistency_checks=true;
        inplace_update_num_locks=7429;
        optimize_filters_for_hits=false;
        level_compaction_dynamic_level_bytes=false;
        inplace_update_support=false;
        compaction_style=kCompactionStyleFIFO;
        purge_redundant_kvs_while_flush=true;
        hard_pending_compaction_bytes_limit=0;
        disable_auto_compactions=false;
        report_bg_io_stats=true;]], new_opts, err)

        if err_code ~= nil then
            ngx.say('failed to create options: ' .. err_code .. ' ' .. err_msg)
        else
            ngx.say('create options success')
        end

        local db, err_code, err_msg = rocksdb.open_db(new_opts, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.say('failed to open db: ' .. err_code .. ' ' .. err_msg)
        else
            ngx.say('open db success')
        end
    }
}

--- request
GET /t

--- response_body
create options success
open db success

--- error_code: 200

=== TEST 2: test create options failed
This test will create options failed

--- http_config eval: $::HttpConfig
--- config
location = /t {
    rewrite_by_lua_block {
        local rocksdb = require("rocksdb")
        local options = require("options")
        local opts = options.rocksdb_options_create()
        local new_opts = options.rocksdb_options_create()

        local _, err_code, err_msg = options.rocksdb_get_options_from_string(
        opts,
        [[create_if_missing=true;
        max_successive_merges=5497;
        max_sequential_skip_in_iterations=4294971408;
        arena_block_size=1893;
        target_file_size_multiplier=35;
        min_write_buffer_number_to_merge=9;
        max_write_buffer_number=84;
        write_buffer_size=1653;
        max_compaction_bytes=64;
        max_bytes_for_level_multiplier=60;
        compression=kNoCompression;
        bottommost_compression=kDisableCompressionOption;
        min_partial_merge_operands=7576;
        level0_stop_writes_trigger=33;
        table_factory=PlainTable;
        memtable_factory=SkipListFactory;
        compression=kNoCompression;
        bottommost_compression=kDisableCompressionOption;
        compaction_style=kCompactionStyleFIFO;
        hard_pending_compaction_bytes_limit=0;
        compaction_filter_factory=mpudlojcujCompactionFilterFactory;
        ]], new_opts, err)
        if err_code ~= nil then
            ngx.say('failed to create options: ' .. err_code .. ' ' .. err_msg)
        else
            ngx.say('create options success')
        end
    }
}

--- request
GET /t

--- response_body
failed to create options: GetOptionErr Invalid argument: Can't parse option compaction_filter_factory

--- error_code: 200

=== TEST 3: test create options by api
This test will open new options

--- http_config eval: $::HttpConfig
--- config
location = /t {
    rewrite_by_lua_block {
        local rocksdb = require("rocksdb")
        local options = require("options")
        local opts = options.rocksdb_options_create()

        local opts_table = {
            ["create_if_missing"] = {true},
            ["max_bytes_for_level_base"] = {986},
            ["bloom_locality"] = {8016},
            ["target_file_size_base"] = {4294976376},
            ["num_levels"] = {99},
            ["level0_slowdown_writes_trigger"] = {22},
            ["level0_file_num_compaction_trigger"] = {14},
            ["soft_rate_limit"] = {530.615385},
            ["soft_pending_compaction_bytes_limit"] = {0},
            ["max_write_buffer_number_to_maintain"] = {84},
            ["memtable_prefix_bloom_size_ratio"] = {0.4642},
            ["inplace_update_num_locks"] = {7429},
            ["optimize_filters_for_hits"] = {false},
            ["level_compaction_dynamic_level_bytes"] = {false},
            ["inplace_update_support"] = {false},
            ["purge_redundant_kvs_while_flush"] = {true},
            ["hard_pending_compaction_bytes_limit"] = {0},
            ["disable_auto_compactions"] = {false},
            ["report_bg_io_stats"] = {true},
            ["optimize_for_point_lookup"] = {500},
            ["max_bytes_for_level_multiplier_additional"] = {500},
            ["max_manifest_file_size"] = {500},
            ["max_bytes_for_level_multiplier_additional"] = {1,1},
            ["compression_options"] = {1,2,2,2},
        }
        options.set_option(opts, opts_table)
        local db, err_code, err_msg = rocksdb.open_db(opts, "./t/servroot/fastcgi_temp/rocksdb_c_simple_example")

        if err_code ~= nil then
            ngx.say('failed to open db: ' .. err_code .. ' ' .. err_msg)
        else
            ngx.say('open db success')
        end
    }
}

--- request
GET /t

--- response_body
open db success



