
from shell import *
import os

class GitFetcherFactory:
    
    def __init__(self):
        pass
    
    def create(self, root_path):
        return GitFetcher(root_path)

GitFetcherFactory = GitFetcherFactory()

class GitFetcher:
    
    def __init__(self, root_path):
        self.root_path = root_path
        
        if not os.path.exists(self.root_path):
            os.makedirs(self.root_path)
        
        pass
    
    def fetch(self, args):
        return self.fetch_commit(*args)
    
    def fetch_commit(self, repo_url, commit):
        path = self.fetch_repo(repo_url)
        shell(path, 'git', 'checkout', commit)
        return path
        
    def fetch_repo(self, repo_url):
        repo_name = self.escape_url(repo_url)
        repo_path = self.root_path + '/' + repo_name
        
        if not os.path.exists(repo_path):
            try:
                shell(self.root_path, 'git', 'clone', repo_url, repo_name)
            except:
                raise GitError('Failed to clone {0} in {1}'
                    .format(repo_url, self.root_path)
                )
        
        shell(repo_path, 'git', 'remote', 'update')
        shell(repo_path, 'git', 'checkout', 'origin')
        
        return repo_path
    
    def escape_url(self, url):
        return self.__class__.__name__ + ':' + path_escape(url)

class GitError:
    
    def __init__(self, descr):
        self.descr = descr
        pass
    
    def __repr__(self):
        return 'GitError: ' + self.descr

