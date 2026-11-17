let cpu_avg = sys cpu -l | get cpu_usage | into int | math avg | math round

let mem = sys mem | ($in.used * 100 / $in.total) | into int

print $"CPU ($cpu_avg)% | RAM ($mem)%"
