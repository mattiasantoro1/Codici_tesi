function inside = indomain(points,domain)

inside = [];
for p=points
    if in_domain(domain,p) == 1
        inside(end+1) = 1;
    else
        inside(end+1) = 0;
    end
end