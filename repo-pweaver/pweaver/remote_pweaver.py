
from shell import *
import os

class RemotePweaver:
    
    def __init__(self, root_path, urlprefix, formatter):
        self.root_path = root_path
        self.fetchers  = { }
        self.formatter = formatter
        self.urlprefix = urlprefix
        
        pass
    
    def add_fetcher(self, name, fetcher_factory):
        self.fetchers[name] = fetcher_factory.create(self.root_path)
        pass
    
    def container(self, request):
        return self.root_path + '/' + request.name()
    
    def pweave(self, 
        service_name,
        service_args,
        script_path
    ):
        request = PweaverRequest(
            service_name, service_args, script_path
        )
        
        container = self.container(request)
        
        if not os.path.exists(container):
            self.pweave_force(request)
        
        htmlpath  = container + '/main.html'
        with open(htmlpath) as handle:
            html = handle.read()
        
        return html
    
    def pweave_force(self, request):
        try:
            fetcher = self.fetchers[request.service_name]
        except KeyError:
            raise NoFetcher
        
        repo_path = fetcher.fetch(request.service_args)
        
        nowebpath = repo_path + '/' + request.script_path
        container = self.container(request)
        htmlpath  = container + '/main.html'
        
        if not os.path.exists(container):
            os.makedirs(container)
        
        self.formatter.run(
            nowebpath,
            container,
            htmlpath,
            self.urlprefix + request.name() + '/'
        )

class PweaverRequest:
    
    def __init__(self,
        service_name,
        service_args,
        script_path
    ):
        self.service_name = service_name
        self.service_args = service_args
        self.script_path  = script_path
        
        pass
    
    def name(self):
        return '{0}:{1}:{2}'.format(
            path_escape(self.service_name),
            ':'.join(map(path_escape, self.service_args)),
            path_escape(self.script_path)
        )

class NoFetcher:
    def __init__(self):
        pass

