let cpu_usage = sys cpu -l | get cpu_usage | into int

let cpu_avg = $cpu_usage | math avg | math round

let cpu_max = $cpu_usage | math max

let cpu_min = $cpu_usage | math min

let mem = sys mem | ($in.used * 100 / $in.total) | into int

print $"CPU AVG ($cpu_avg)% | CPU MAX ($cpu_max)% | CPU MIN ($cpu_min)% | RAM ($mem)%"

