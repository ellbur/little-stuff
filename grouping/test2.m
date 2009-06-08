
Dir1 = '/tmp/test/jeff/';
Dir2 = '/tmp/test/owen/';

Files1 = files_in_dir(Dir1);
Files2 = files_in_dir(Dir2);

Files = [ Files1 Files2 ]

Link = file_link_table(Files);
[ Group Grouper ] = do_group_2(Link, 2);

Group
Suggest = [ ones(1, length(Files1)), 2*ones(1, length(Files2)) ]

Grouper.Rater = @rate_best;
Score1A = rate_group(Grouper, Group)
Score1B = rate_group(Grouper, Suggest)

Grouper.Rater = @rate_cohesion;
Score2A = rate_group(Grouper, Group)
Score2B = rate_group(Grouper, Suggest)
