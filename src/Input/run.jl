function run_cap18(path=input_data_dir)
    dir = path * "/../"
    stdout = dir * "out.txt"
    stderr = dir * "errs.txt"
    cmd = `Cap18 "$path"`
    run(pipeline(cmd, stdout=stdout, stderr=stderr));
    return nothing
end
