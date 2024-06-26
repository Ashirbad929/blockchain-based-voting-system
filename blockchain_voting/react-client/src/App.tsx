import { Suspense } from 'react';
import { Route, BrowserRouter as Router, Routes } from 'react-router-dom';
import './App.css';
import { NAVIGATION } from './config/const';

import { Flex, Progress } from '@chakra-ui/react';
import Admin from './views/pages/admin';
import Home from './views/pages/home';
import Login from './views/pages/login';
import Logout from './views/pages/logout';
import Vote from './views/pages/vote';

// const Home = lazy(() => import('./views/pages/home'));

function App() {
	return (
		<Flex minHeight={'100vh'} width={'100vw'} className='bg-background text-white'>
			<Router>
				<Suspense fallback={<Loading />}>
					<Routes>
						<Route path={NAVIGATION.LOGIN} element={<Login />} />
						<Route path={NAVIGATION.HOME} element={<Home />} />
						<Route path={NAVIGATION.ADMIN} element={<Admin />} />
						<Route path={NAVIGATION.VOTE} element={<Vote />} />
						<Route path={NAVIGATION.LOGOUT} element={<Logout />} />
						{/* <Route path='*' element={<PageNotFound />} /> */}
					</Routes>
				</Suspense>
			</Router>
		</Flex>
	);
}

const Loading = () => {
	return (
		<Flex
			direction={'column'}
			justifyContent={'center'}
			alignItems={'center'}
			flexDirection='column'
			width={'100vw'}
			height={'100vh'}
		>
			<Flex
				direction={'column'}
				justifyContent={'center'}
				alignItems={'center'}
				flexDirection='column'
				padding={'3rem'}
				rounded={'lg'}
				width={'500px'}
				height={'550px'}
				className='border shadow-xl drop-shadow-xl '
			>
				<Flex justifyContent={'center'} alignItems={'center'} direction={'column'}>
					<Flex justifyContent={'center'} alignItems={'center'} width={'full'}>
						{/* <Image src={LOGO} width={'280px'} className='shadow-lg rounded-full animate-pulse' /> */}
					</Flex>
					<Progress size='xs' isIndeterminate width={'150%'} rounded={'lg'} marginTop={'-3rem'} />
				</Flex>
			</Flex>
		</Flex>
	);
};

export default App;
