
from remote_pweaver import *
from gitfetch import *
from rstformatter import *
import os

pw = RemotePweaver(
    os.environ['HOME'] + '/public_html/pweaver-server/cache',
    'http://localhost/~owen/pweaver-server/cache/',
    RSTFormatter
)
pw.add_fetcher('git', GitFetcherFactory)

pw.pweave_force(PweaverRequest(
    'git',
    ['/home/owen/stuff/dumping-ground/emily', 'HEAD'],
    'foo.pnw'
))

